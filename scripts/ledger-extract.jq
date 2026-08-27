# Shared ledger extractor for hooks/stop-ledger and scripts/ledger.sh.
#
# ONE rule governs every branch: an unreadable ledger must never resolve toward "done". Both halves
# of the gate share this program so they cannot disagree, and the disagreement that matters is each
# independently deciding "I can't parse this, so nothing is open" — which turns a stalled run into a
# green light from both at once.
#
# It also keeps the SLICE attached to every row. A field run ended at 89% with one of four
# capabilities at zero passed rows, invisible because an earlier version flattened the tree into a
# bag of rows and every downstream surface could then only print one aggregate.
#
# Emits: {ok, why, warn, rows, counts:{..., bySlice, deadSlices}}
# ok=false means DO NOT TRUST THE NUMBERS: the hook blocks, ledger.sh exits 2.
# warn is advisory — surfaced, never blocking, because these are heuristics and a false positive
# must not be able to wedge someone's run.

def vocab: ["todo","building","passed","dropped","blocked"];
def dropkinds: ["void","moved"];

# A slice is any object holding a `rows` array. A row is any object with a `status` that is not
# itself a container — a slice may carry its own status and must not be counted as one of its rows.
def slices: [.. | objects | select((.rows | type) == "array")];
def orphans: [.. | objects | select(has("status") and ((.rows | type) != "array"))];
def malformed_members: [.. | objects | select((.rows | type) == "array") | .rows[] | select(type != "object")];

. as $doc
| (try ($doc | slices) catch []) as $sl
| (try ($doc | orphans) catch []) as $orph
| ([ $sl[] | . as $s | ($s.rows[] | select(type == "object") | select(has("status"))
      | . + {_slice: ($s.id // "?"), _cap: ($s.capability // "")}) ]) as $owned
| ([ $orph[] | select([ $sl[] | .rows[]? | select(type=="object") ] | index(.) | not)
      | . + {_slice: null, _cap: ""} ]) as $loose
| ($owned + $loose) as $r
| (try ($doc | malformed_members) catch []) as $bad
| ($r | map(select((.status | type) != "string" or ((.status | IN(vocab[])) | not)))) as $badstatus
| ([$r[] | .id // empty | select(type == "string")]) as $ids
# NB: `$ids - ($ids|unique)` looks right and is not — jq's `-` is set difference, so it removes
# every copy and reports no duplicates at all. Group instead.
| ([$ids | group_by(.)[] | select(length > 1) | .[0]]) as $dupes
# A drop is the one legal way to shrink the denominator, so it is the one that needs typing.
# `void` = the requirement does not exist in the world, nothing is owed. `moved` = it still exists
# and changed shape, so a successor is mandatory. An untyped drop, or a `moved` whose successor is
# not in this ledger, is how a capability quietly empties out — observed in the field.
| ([$r[] | select(.status == "dropped") | select(((.dropped_kind // "") | IN(dropkinds[])) | not)
    | .id // "?"]) as $untyped
| ([$r[] | select(.status == "dropped" and (.dropped_kind // "") == "moved")
    | select([(.replaced_by // []) | if type=="array" then .[] else . end] as $rb
             | ($rb | length) == 0 or any($rb[]; . as $x | ($ids | index($x)) == null))
    | .id // "?"]) as $dangling
# Stage 2's output lands on the SLICE (`shape`, `trap`, `delete`) or it lands nowhere. In the only
# field ledger that exists all three were absent on 4 of 4 slices while recon ran and cost real
# tokens, and `force` was written on both 0.9-confidence slices and skipped on both at 0.65 — the
# depth-by-confidence rule exactly inverted. These warn rather than refuse, for the same reason
# untyped drops warn: requiring the keys outright would brick every ledger written before them.
| ([$sl[] | select([.rows[]? | select(type=="object") | select(has("status"))] | length > 0)
    | select((((.confidence | tonumber?) // null) as $c | $c != null and $c < 0.7))
    | select((((.shape // "") | tostring) | length) == 0) | .id // "?"]) as $noshape
| ([$sl[] | select((((.shape // "") | tostring) | length) > 0)
    | select((((.trap  // "") | tostring) | length) == 0) | .id // "?"]) as $notrap
# THE SLICE'S OWN CHECK MUST BE A ROW. Field failure, three instances: a run closed with 135 rows
# passed and every page wrong, because the goal was "make B look like A" and not one row compared B
# to A — every row was a true statement ABOUT B. Twice more, the row a human had annotated as "the
# slice's real check" was the one that got dropped. Mark exactly one row per slice `is_check: true`.
# Missing -> warn (bricking every existing ledger is worse). But a check-row dropped as `void` is
# REFUSED: `void` means the requirement does not exist in the world, and a slice whose own check does
# not exist is an unbuilt slice, not a satisfied one. If the check was wrong, that is a `moved` drop
# with a successor — re-frame it in the open.
| ([$sl[] | select([.rows[]? | select(type=="object") | select(has("status"))] | length > 0)
    | select([.rows[]? | select(type=="object") | select(.is_check == true)] | length == 0)
    | .id // "?"]) as $nocheckrow
| ([$sl[] | . as $s | ($s.rows[]? | select(type=="object")
    | select(.is_check == true and .status == "dropped" and (.dropped_kind // "") == "void")
    | ($s.id // "?") + "/" + (.id // "?"))]) as $voidcheck
| if ($doc | type) != "array" and ($doc | type) != "object" then
    {ok:false, why:"ledger is neither an array nor an object", warn:[], rows:[], counts:null}
  elif ($bad | length) > 0 then
    {ok:false, why:"\($bad|length) element(s) inside a rows array are not objects — unreadable rows are treated as open, never as done", warn:[], rows:$r, counts:null}
  elif ($r | length) == 0 then
    {ok:false, why:"no rows found at any depth — a ledger of slices alone cannot see a missing function", warn:[], rows:[], counts:null}
  elif ($badstatus | length) > 0 then
    {ok:false,
     why:"\($badstatus|length) row(s) carry a status outside [todo, building, passed, dropped, blocked]: \($badstatus | map((.id // "?") + "=" + (.status | tostring)) | .[0:6] | join(", ")) — an unrecognised status is an unbuilt row hiding from both counters",
     warn:[], rows:$r, counts:null}
  elif ($dupes | length) > 0 then
    {ok:false, why:"duplicate row id(s): \($dupes | unique | join(", ")) — duplicates inflate the denominator and the passed count together", warn:[], rows:$r, counts:null}
  elif ($voidcheck | length) > 0 then
    {ok:false, why:"a slice's own check-row was dropped as `void`: \($voidcheck | join(", ")) — `void` means the requirement does not exist, and a slice whose check does not exist is unbuilt, not satisfied. If the check was wrong, re-frame it in the open as a `moved` drop with a successor", warn:[], rows:$r, counts:null}
  elif ($dangling | length) > 0 then
    {ok:false, why:"`moved` drop(s) naming no successor in this ledger: \($dangling | join(", ")) — a requirement that moved leaves a replacement row, not a hole", warn:[], rows:$r, counts:null}
  else
    ($r | length) as $n
    | ([$r[] | select(.status == "todo")]      | length) as $todo
    | ([$r[] | select(.status == "building")]  | length) as $building
    | ([$r[] | select(.status == "passed")]    | length) as $passed
    | ([$r[] | select(.status == "dropped")]   | length) as $dropped
    | ([$r[] | select(.status == "blocked")]   | length) as $blocked
    # `from: "discovered"` was the documented shape and went unused; `discovered: true` is what the
    # field actually writes. Read both, and believe either.
    | ([$r[] | select(.discovered == true or (.from // "") == "discovered")] | length) as $disc
    | ([ $sl[] | . as $s
         | ([$s.rows[]? | select(type=="object") | select(has("status"))]) as $sr
         | select(($sr | length) > 0)
         | {id: ($s.id // "?"), capability: ($s.capability // ""),
            passed:  ([$sr[] | select(.status=="passed")]  | length),
            open:    ([$sr[] | select(.status=="todo" or .status=="building")] | length),
            blocked: ([$sr[] | select(.status=="blocked")] | length),
            dropped: ([$sr[] | select(.status=="dropped")] | length),
            total:   ($sr | length)} ]) as $bys
    | if ($todo + $building + $passed + $dropped + $blocked) != $n then
        {ok:false, why:"status buckets do not sum to the row count — refusing to report a number that does not add up", warn:[], rows:$r, counts:null}
      else
        {ok:true, why:"", rows:$r,
         # A "does this row grade the run rather than the product" heuristic was written here and
         # cut the same hour: it fired on two field rows ("each claim is backed by a real
         # read-back", "anything not done is stated as not done") that were closed with concrete
         # evidence naming real record ids. A quantifier scoped to a NAMED ARTIFACT is walkable;
         # only one scoped to the run itself is not, and no cheap test tells them apart.
         warn: (# Advisory, not blocking: requiring dropped_kind outright would brick every ledger
                # written before it existed, and the dead-slice floor is the gate that actually
                # catches the failure typing only diagnoses.
                (if ($nocheckrow|length) > 0
                 then ["slice(s) whose own `check` is not carried by any row (mark one `is_check: true`) — a run can pass every row and still miss the thing the slice was for: " + ($nocheckrow|join(", "))]
                 else [] end)
                + (if ($untyped|length) > 0
                 then ["untyped drop(s) — say `void` (the requirement does not exist) or `moved` (it changed shape and owes a successor): " + ($untyped|join(", "))]
                 else [] end)
                + (if ($noshape|length) > 0
                   then ["slice(s) below 0.7 confidence carrying no `shape` — recon either did not run or its answer died with the session: " + ($noshape|join(", "))]
                   else [] end)
                + (if ($notrap|length) > 0
                   then ["slice(s) with a `shape` and no `trap` — a shape without its trap is a diagram, and recheck receives nothing checkable: " + ($notrap|join(", "))]
                   else [] end)),
         counts:{open:($todo+$building), resolved:($passed+$dropped+$blocked),
                 passed:$passed, dropped:$dropped, blocked:$blocked,
                 todo:$todo, building:$building,
                 declared:($n-$disc), discovered:$disc, total:$n,
                 bySlice:$bys,
                 # Dead = a capability with work still to do that has delivered nothing. Two
                 # exclusions, each earned: a slice whose rows were ALL dropped was cut, and
                 # attribution on those drops already covers it; and a slice whose only unresolved
                 # rows are BLOCKED must not hold the stop, or the floor wedges the run on the one
                 # thing it cannot do. (A slice-level `status` was considered and cut — it is a way
                 # to dodge rows wholesale and it appeared nowhere in the field.)
                 deadSlices: [ $bys[] | select(.passed == 0 and .open > 0) | .id ]}}
      end
  end
