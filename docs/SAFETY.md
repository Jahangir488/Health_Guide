# Medical safety boundary

This repository is a prototype for software development and UI testing only. It is not clinically validated and must not be used to diagnose, triage, or treat real patients.

Before a public pilot:

1. Have a qualified Bangladesh-appropriate clinician review every symptom question, red-flag rule, and result message.
2. Have a qualified pharmacist/clinician validate medicine entries against authoritative, locally relevant sources; record source, country, version, review date, and reviewer.
3. Conduct structured testing for false reassurance, emergency symptoms, missing information, Bengali translation quality, pregnancy, children, older adults, chronic illness, allergies, and drug interactions.
4. Never allow generative AI to override deterministic emergency rules or prescribe medicine/doses based on symptoms alone.
5. Display uncertainty and provide appropriate escalation guidance; absence of a listed red flag does not mean the user is safe.
6. Do not collect real patient data in the prototype. Before adding accounts/history, complete a privacy impact assessment, consent and retention design, access controls, encryption, logging, and incident response plan.
7. Seek regulatory advice from Bangladesh's relevant health authorities about whether intended functionality triggers medical-device/software requirements.
8. Provide a clear limitation notice, reporting mechanism, content-review process, and rapid correction pathway.

## Prototype rule behavior

The demo recognizes only a small set of warning symptoms: severe difficulty breathing, chest pain, fainting/loss of consciousness, and severe bleeding. This list is intentionally incomplete and is not an adequate clinical triage protocol. Any one of these should display urgent guidance, but many other emergencies are possible.

No assessment endpoint returns a diagnosis or medicine recommendation.
