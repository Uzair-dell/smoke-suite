/-
  SumFirstN.lean
  Proof that the sum of the first n natural numbers equals n*(n-1)/2.

  Companion to the HTML smoke tests in this repository.
-/

import Mathlib.Algebra.BigOperators.Basic
import Mathlib.Tactic

open Finset

/-- The sum 0 + 1 + ... + (n-1) multiplied by 2 equals n * (n - 1). -/
theorem sum_range_id_mul_two (n : Nat) :
    (∑ i in range n, i) * 2 = n * (n - 1) := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [sum_range_succ, ih]
    ring_nf
    omega

/-- Closed form with division: sum of 0..n-1 equals n*(n-1)/2. -/
theorem sum_range_id_div (n : Nat) :
    ∑ i in range n, i = n * (n - 1) / 2 := by
  have h := sum_range_id_mul_two n
  omega

/-- A concrete verification: 0 + 1 + 2 + 3 + 4 = 10. -/
theorem sum_five : (∑ i in range 5, i) = 10 := by
  decide

/-- For n >= 2, the sum of the first n naturals is even (divisible by 2). -/
theorem two_dvd_sum_range (n : Nat) (h : 2 ≤ n) :
    2 ∣ ∑ i in range n, i := by
  rw [sum_range_id_div]
  exact Nat.dvd_mul_left 2 (n * (n - 1) / 2)

/-- Sanity check: the closed form agrees with direct computation at n = 10. -/
theorem sum_ten : (∑ i in range 10, i) = 45 := by
  decide
