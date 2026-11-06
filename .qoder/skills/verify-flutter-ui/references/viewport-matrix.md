# Viewport matrix — what to shoot for this app

Always shoot **360x640** and **text scale 2.0** for every changed screen. Add the per-screen rows below.

| Screen / feature | Extra viewports | Extra states |
|---|---|---|
| Splash | 360x640, 1280x800 | cold start, already-authenticated start |
| Welcome | 360x640, 768x1024 | short screen (small phone), landscape phone |
| Phone entry | 360x640 | keyboard open, country picker open, long error message |
| OTP | 360x640 | keyboard open, paste 6 digits, wrong code error, resend timer at 0 |
| Signed-in home (shell) | 360x640, 768x1024, 1280x800 | loading, error, empty |
| Any list screen | 360x640 | 0 items, 1 item, 100 items, very long item names |
| Any form | 360x640 | every field with its error, keyboard open, submit disabled/enabled/loading |
| Bottom sheet | 360x640 | full content, content taller than screen, keyboard open |
| Dialog | 360x640 | long title, long body, two-button row at 2.0 scale |

## Screenshot naming

Save to `artifacts/ui/<screen>-<viewport>-<state>.png`, e.g.
`artifacts/ui/phone-entry-360x640-keyboard-open.png`.

Reference the exact paths in your verification verdict. If `artifacts/` is not gitignored, tell the user rather than committing screenshots.
