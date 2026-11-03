### Week 5 — AI Code Review

- **Code reviewed:** BankAccount class (AI tool: Claude)
- **Weak prompt issues found:** 5 (2 real bugs, 3 style suggestions; it also rewrote code)
- **Strong prompt issues found:** 7 (2 HIGH, 3 MEDIUM, 2 LOW; no rewrite)
- **Issues I agreed with:** 3
- **Issues I rejected:** 0
- **Issue the AI missed:** The owner setter saves the name without trimming, so " Ama " is stored with leading and trailing spaces.
- **What I learned:** Naming the review criteria and banning rewrites turned vague advice into ranked, testable findings.
