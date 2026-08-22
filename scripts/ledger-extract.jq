# Shared ledger extractor for hooks/stop-ledger and scripts/ledger.sh.
#
# ONE rule governs every branch here: an unreadable ledger must never resolve toward "done".
# Both halves of the gate share this program precisely so they cannot disagree, and the
# disagreement that matters is the one where each independently decides "I can't parse this,
# so nothing is open" — which turns the 90% stall into a green light from both at once.
#
# Emits: {ok, why, rows, counts:{open,resolved,passed,dropped,blocked,todo,building,declared,discovered,total}}
# ok=false means DO NOT TRUST THE NUMBERS: the hook blocks, ledger.sh exits 2.
#
# Rows are collected at ANY depth, because slice -> sub-slice -> rows is a shape a model
# writing its own ledger reaches for on a large build, and a one-level extractor silently
# returns zero rows for it.

def vocab: ["todo","building","passed","dropped","blocked"];

# Every object anywhere in the document that claims to be a row. A container is NOT a row even
# when it carries its own status: slices in the documented shape have both a `status` and a
# `rows` array, and counting them inflated the denominator by one per slice on the first real
# ledger this was pointed at (18 rows read as 23).
def rows: [.. | objects | select(has("status") and (has("rows") | not))];

# Anything sitting inside a "rows" array that is not an object is a row we cannot read.
def malformed_members: [.. | objects | select(has("rows")) | .rows
                        | if type == "array" then (.[] | select(type != "object")) else . end];

. as $doc
| (try ($doc | rows) catch []) as $r
| (try ($doc | malformed_members) catch []) as $bad
| ($r | map(select((.status | type) != "string" or ((.status | IN(vocab[])) | not)))) as $badstatus
| ([$r[] | .id // empty | select(type == "string")]) as $ids
# NB: `$ids - ($ids|unique)` looks right and is not — jq's `-` is set difference, so it
# removes every copy and reports no duplicates at all. Group instead.
| ([$ids | group_by(.)[] | select(length > 1) | .[0]]) as $dupes
| if ($doc | type) != "array" and ($doc | type) != "object" then
    {ok:false, why:"ledger is neither an array nor an object", rows:[], counts:null}
  elif ($bad | length) > 0 then
    {ok:false, why:"\($bad|length) element(s) inside a rows array are not objects — unreadable rows are treated as open, never as done", rows:$r, counts:null}
  elif ($r | length) == 0 then
    {ok:false, why:"no rows found at any depth — a ledger of slices alone cannot see a missing function", rows:[], counts:null}
  elif ($badstatus | length) > 0 then
    {ok:false,
     why:"\($badstatus|length) row(s) carry a status outside [todo, building, passed, dropped, blocked]: \($badstatus | map((.id // "?") + "=" + (.status | tostring)) | .[0:6] | join(", ")) — an unrecognised status is an unbuilt row hiding from both counters",
     rows:$r, counts:null}
  elif ($dupes | length) > 0 then
    {ok:false, why:"duplicate row id(s): \($dupes | unique | join(", ")) — duplicates inflate the denominator and the passed count together", rows:$r, counts:null}
  else
    ($r | length) as $n
    | ([$r[] | select(.status == "todo")]      | length) as $todo
    | ([$r[] | select(.status == "building")]  | length) as $building
    | ([$r[] | select(.status == "passed")]    | length) as $passed
    | ([$r[] | select(.status == "dropped")]   | length) as $dropped
    | ([$r[] | select(.status == "blocked")]   | length) as $blocked
    | ([$r[] | select((.from // "") == "discovered")] | length) as $disc
    | if ($todo + $building + $passed + $dropped + $blocked) != $n then
        {ok:false, why:"status buckets do not sum to the row count — refusing to report a number that does not add up", rows:$r, counts:null}
      else
        {ok:true, why:"", rows:$r,
         counts:{open:($todo+$building), resolved:($passed+$dropped+$blocked),
                 passed:$passed, dropped:$dropped, blocked:$blocked,
                 todo:$todo, building:$building,
                 declared:($n-$disc), discovered:$disc, total:$n}}
      end
  end
