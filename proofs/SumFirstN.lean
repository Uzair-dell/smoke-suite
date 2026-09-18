import Mathlib.Algebra.BigOperators.Basic
import Mathlib.Tactic

open Finset

/-!
  SumFirstN.lean
  Properties of the sum of the first n natural numbers.
-/

/-- Concrete check: 0 + 1 + 2 + 3 + 4 = 10. -/
theorem sum_five : (∑ i in range 5, i) = 10 := by decide

/-- Concrete check: 0 + 1 + ... + 9 = 45. -/
theorem sum_ten : (∑ i in range 10, i) = 45 := by decide

/-- Concrete check: 0 + 1 + ... + 5 = 15. -/
theorem sum_six : (∑ i in range 6, i) = 15 := by decide

/-- Closed form: the sum of 0..n-1 equals n*(n-1)/2.
    This is Mathlib theorem Finset.sum_range_id. -/
theorem sum_range_formula (n : Nat) :
    (∑ i in range n, i) = n * (n - 1) / 2 :=
  sum_range_id n

/-- The sum of the first n naturals is 0 at n = 0 and n = 1. -/
theorem sum_zero : (∑ i in range 0, i) = 0 := by decide
theorem sum_one : (∑ i in range 1, i) = 0 := by decide
