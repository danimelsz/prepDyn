#!/usr/bin/env python3

def merge_overlapping_sequences(seq_list, min_overlap=10, mismatch_rate=0.05):
    merge_log = []
    if not seq_list:
        return [], merge_log
        
    seq_list_upper = [s.upper() for s in seq_list]
        
    merged_any = True
    while merged_any:
        merged_any = False
        for i in range(len(seq_list_upper)):
            for j in range(i + 1, len(seq_list_upper)):
                seq1 = seq_list_upper[i]
                seq2 = seq_list_upper[j]
                
                # 1. Check containment first
                if seq1 in seq2:
                    merge_log.append(f"Amplicon of {len(seq1)}bp was fully contained in {len(seq2)}bp amplicon (merged).")
                    seq_list_upper.pop(i)
                    merged_any = True
                    break
                if seq2 in seq1:
                    merge_log.append(f"Amplicon of {len(seq2)}bp was fully contained in {len(seq1)}bp amplicon (merged).")
                    seq_list_upper.pop(j)
                    merged_any = True
                    break
                    
                # 2. Check overlap
                overlap_len = 0
                best_merged = None
                
                len1, len2 = len(seq1), len(seq2)
                max_k = min(len1, len2)
                
                # Check seq1 suffix matching seq2 prefix
                for k in range(max_k, min_overlap - 1, -1):
                    s1_suffix = seq1[-k:]
                    s2_prefix = seq2[:k]
                    
                    if s1_suffix == s2_prefix:
                        overlap_len = k
                        best_merged = seq1 + seq2[k:]
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
                        break
                        
                # Check seq2 suffix matching seq1 prefix
                if not best_merged:
                    for k in range(max_k, min_overlap - 1, -1):
                        s2_suffix = seq2[-k:]
                        s1_prefix = seq1[:k]
                        
                        if s2_suffix == s1_prefix:
                            overlap_len = k
                            best_merged = seq2 + seq1[k:]
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
                            break
                        
                if best_merged:
                    merge_log.append(f"Merged {len1}bp and {len2}bp amplicons with an overlap of {overlap_len}bp.")
                    seq_list_upper.pop(j)
                    seq_list_upper[i] = best_merged
                    merged_any = True
                    break
            if merged_any:
                break
                
    return seq_list_upper, merge_log


# ==========================================
# TEST CASES
# ==========================================

print("--- CASE 1: Perfect Overlap (15 bp) ---")
# seq1 ends with:   ...GCTAGCTAGCTAGC
# seq2 starts with:    GCTAGCTAGCTAGC...
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGC"
seq2 =                 "GCTAGCTAGCTAGCTTTTAAAACCC"
result, log = merge_overlapping_sequences([seq1, seq2], min_overlap=10)
print(f"Result Sequences: {result}")
print(f"Log: {log}\n")

print("--- CASE 2: Overlap with Mismatch (20 bp overlap, 1 error) ---")
# Testing the 5% mismatch tolerance. 1 error in 20bp is exactly 5%.
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGCTAGC"
seq2 =             "GCTAGCTAGCTxGCTAGCTTTTAAAACCC" # 'x' instead of 'A'
result, log = merge_overlapping_sequences([seq1, seq2], min_overlap=10, mismatch_rate=0.05)
print(f"Result Sequences: {result}")
print(f"Log: {log}\n")

print("--- CASE 3: Full Containment ---")
# seq2 is completely inside seq1
seq1 = "ATGCGTACGTTAGCTAGCTAGCTAGCTAGC"
seq2 =        "CGTTAGCTAGCTA"
result, log = merge_overlapping_sequences([seq1, seq2], min_overlap=10)
print(f"Result Sequences: {result}")
print(f"Log: {log}\n")

print("--- CASE 4: No Overlap (or overlap < 10bp) ---")
# Only overlap by 5bp ("ATGCG"), threshold is 10.
seq1 = "ATGCGTACGTTAGCTAGCTAG"
seq2 =                      "ATGCGTTTTAAAACCC"
result, log = merge_overlapping_sequences([seq1, seq2], min_overlap=10)
print(f"Result Sequences: {result}")
print(f"Log: {log}\n")