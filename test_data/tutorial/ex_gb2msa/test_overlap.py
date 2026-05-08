#!/usr/bin/env python3

def merge_overlapping_sequences(seq_list, min_overlap=10, mismatch_rate=0.05, labels=None):
    merge_log = []
    if not seq_list:
        return [], merge_log, []

    if labels is None:
        labels = [f"amplicon_{idx + 1}" for idx in range(len(seq_list))]

    fragments = [
        {"seq": seq.upper(), "labels": [label]}
        for seq, label in zip(seq_list, labels)
    ]
        
    merged_any = True
    while merged_any:
        merged_any = False
        for i in range(len(fragments)):
            for j in range(i + 1, len(fragments)):
                fragment1 = fragments[i]
                fragment2 = fragments[j]
                seq1 = fragment1["seq"]
                seq2 = fragment2["seq"]
                
                # 1. Check containment first
                if seq1 in seq2:
                    merge_log.append({
                        "type": "containment",
                        "removed_labels": fragment1["labels"][:],
                        "kept_labels": fragment2["labels"][:],
                        "deleted_string": seq1
                    })
                    fragments[j]["labels"].extend(fragment1["labels"])
                    fragments.pop(i)
                    merged_any = True
                    break
                if seq2 in seq1:
                    merge_log.append({
                        "type": "containment",
                        "removed_labels": fragment2["labels"][:],
                        "kept_labels": fragment1["labels"][:],
                        "deleted_string": seq2
                    })
                    fragments[i]["labels"].extend(fragment2["labels"])
                    fragments.pop(j)
                    merged_any = True
                    break
                    
                # 2. Check overlap
                overlap_len = 0
                best_merged = None
                deleted_string = ""
                
                len1, len2 = len(seq1), len(seq2)
                max_k = min(len1, len2)
                
                # Check seq1 suffix matching seq2 prefix
                for k in range(max_k, min_overlap - 1, -1):
                    s1_suffix = seq1[-k:]
                    s2_prefix = seq2[:k]
                    
                    if s1_suffix == s2_prefix:
                        overlap_len = k
                        best_merged = seq1 + seq2[k:]
                        deleted_string = seq2[:k]
                        break
                        
                    max_mismatches = max(2, int(mismatch_rate * k))
                    mismatches = 0
                    for a, b in zip(s1_suffix, s2_prefix):
                        if a != b:
                            mismatches += 1
                            if mismatches > max_mismatches:
                                break
                    if mismatches <= max_mismatches:
                        overlap_len = k
                        best_merged = seq1 + seq2[k:]
                        deleted_string = seq2[:k]
                        break
                        
                # Check seq2 suffix matching seq1 prefix
                if not best_merged:
                    for k in range(max_k, min_overlap - 1, -1):
                        s2_suffix = seq2[-k:]
                        s1_prefix = seq1[:k]
                        
                        if s2_suffix == s1_prefix:
                            overlap_len = k
                            best_merged = seq2 + seq1[k:]
                            deleted_string = seq1[:k]
                            break
                            
                        max_mismatches = max(2, int(mismatch_rate * k))
                        mismatches = 0
                        for a, b in zip(s2_suffix, s1_prefix):
                            if a != b:
                                mismatches += 1
                                if mismatches > max_mismatches:
                                    break
                        if mismatches <= max_mismatches:
                            overlap_len = k
                            best_merged = seq2 + seq1[k:]
                            deleted_string = seq1[:k]
                            break
                        
                if best_merged:
                    merge_log.append({
                        "type": "overlap",
                        "left_labels": fragment1["labels"][:],
                        "right_labels": fragment2["labels"][:],
                        "overlap_length": overlap_len,
                        "deleted_string": deleted_string
                    })
                    fragments.pop(j)
                    fragments[i] = {
                        "seq": best_merged,
                        "labels": fragment1["labels"] + fragment2["labels"]
                    }
                    merged_any = True
                    break
            if merged_any:
                break
                
    return [fragment["seq"] for fragment in fragments], merge_log, [fragment["labels"][:] for fragment in fragments]


# ==========================================
# TEST CASES
# ==========================================

print("--- CASE 1: Perfect Overlap (15 bp) ---")
# seq1 ends with:   ...GCTAGCTAGCTAGC
# seq2 starts with:    GCTAGCTAGCTAGC...
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGC"
seq2 =                 "GCTAGCTAGCTAGCTTTTAAAACCC"
result, log, groups = merge_overlapping_sequences([seq1, seq2], min_overlap=10, labels=["seq1", "seq2"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")

print("--- CASE 2: Overlap with Mismatch (20 bp overlap, 1 error) ---")
# Testing the 5% mismatch tolerance. 1 error in 20bp is exactly 5%.
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGCTAGC"
seq2 =             "GCTAGCTAGCTxGCTAGCTTTTAAAACCC" # 'x' instead of 'A'
result, log, groups = merge_overlapping_sequences([seq1, seq2], min_overlap=10, mismatch_rate=0.05, labels=["seq1", "seq2"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")

print("--- CASE 3: Full Containment ---")
# seq2 is completely inside seq1
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGCTAGC"
seq2 =        "CGTTAGCTAGCTA"
result, log, groups = merge_overlapping_sequences([seq1, seq2], min_overlap=10, labels=["seq1", "seq2"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")

print("--- CASE 4: No Overlap (or overlap < 10bp) ---")
# Only overlap by 5bp ("ATGCG"), threshold is 10.
seq1 = "ATGCGTACGTTAGCTAGCTAG"
seq2 =                      "ATGCGTTTTAAAACCC"
result, log, groups = merge_overlapping_sequences([seq1, seq2], min_overlap=10, labels=["seq1", "seq2"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")

print("--- CASE 5: Three Amplicons with Chained Flanking Overlaps ---")
# seq1 overlaps seq2, and seq2 overlaps seq3
seq1 = "AAAACCCC"
seq2 =     "CCCCGGGG"
seq3 =         "GGGGTTTT"
result, log, groups = merge_overlapping_sequences([seq1, seq2, seq3], min_overlap=4, labels=["seq1", "seq2", "seq3"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")

print("--- CASE 6: Three Amplicons with Full Containment Plus Flanking Overlap ---")
# seq2 is fully contained in seq1, and then seq1 overlaps seq3
seq1 = "AAAACCCCGGGG"
seq2 =     "CCCC"
seq3 =         "GGGGTTTT"
result, log, groups = merge_overlapping_sequences([seq1, seq2, seq3], min_overlap=4, labels=["seq1", "seq2", "seq3"])
print(f"Result Sequences: {result}")
print(f"Log: {log}")
print(f"Groups: {groups}\n")
