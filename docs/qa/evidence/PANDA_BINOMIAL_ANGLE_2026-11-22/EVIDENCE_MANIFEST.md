# Evidence manifest: Panda / Binomial / Angle Pixel 6a acceptance

Report: `docs/qa/PANDA_BINOMIAL_ANGLE_PIXEL_ACCEPTANCE.md`. Scenario IDs (F-, A-, R-, P-) refer to that report.

- **Capture:** 2026-11-22, 05:09–05:45 device time. Pixel 6a, Android 17. App build `741abb06…2309` from commit `4494356`.
- **Copied:** from the temporary capture directory on the same day. Each copy was checked byte-for-byte against its source.
- **Not regenerated:** nothing here was recaptured or edited after the session, except one line in `measurements/h.sh`, where a local user path was replaced with a `UAT_DIR` placeholder.
- **Machine-checkable hashes:** `EVIDENCE_MANIFEST.sha256`. Run `sha256sum -c EVIDENCE_MANIFEST.sha256` in this directory.

## In the repository (49 files)

| File | Bytes | Capture type | Scenario | SHA-256 |
|---|---|---|---|---|
| `accessibility/A0_labels.txt` | 904 | Accessibility labels (uiautomator) | A-1 | `b0ab8416bf177f37d162bdcee25dc1fd68613f53ac53fe69077a7577c8c0ab74` |
| `accessibility/F0_labels.txt` | 607 | Accessibility labels (uiautomator) | F-1 | `457944bbb793facec87abe05233d25f694ca226c8ff0b177d57794559e8c1df3` |
| `device/app_files_after.sha256` | 639 | App data file hashes | P-2 | `f226fc880b198e310cd234528f03e4f4db12339667c4c568600a774fa8f84f8f` |
| `device/app_files_before.sha256` | 639 | App data file hashes | P-2 | `5e18cb6082cf0d007b6ec50f5f72dfdc87d1eba28b8f30855ea6569e8b24161e` |
| `device/device_settings_after.txt` | 607 | Device settings snapshot | P-3 | `40d408e13c566e5a0fab81df433380a8b5a1f71bffe4ce375480862c43917bdc` |
| `device/device_settings_before.txt` | 607 | Device settings snapshot | P-3 | `40d408e13c566e5a0fab81df433380a8b5a1f71bffe4ce375480862c43917bdc` |
| `measurements/V6_landscape.txt` | 871 | Pixel-hash and readout log | R-2 | `91353565176c887a2693abefdab88ddf1486aab0c0a078b8f0f83c3f70ac1a4c` |
| `measurements/V6_large_text.txt` | 912 | Pixel-hash and readout log | R-4 | `9aa870e7d8d413614b9db042ac70f69e2ad4751e545e10e31d1eafd95f0b7692` |
| `measurements/V6_portrait.txt` | 1,072 | Pixel-hash and readout log | A-2, A-4 | `7730fd53ac25632e96656453951bed44c20794a9f4affc703b42507cd8cd1353` |
| `measurements/V6_rm_quiet.txt` | 1,072 | Pixel-hash and readout log | R-6 | `7730fd53ac25632e96656453951bed44c20794a9f4affc703b42507cd8cd1353` |
| `measurements/h.sh` | 5,432 | Capture helper script (local path replaced) | Method | `7d181c13e2f8ca81f6b2f4a359fc1b7783bc5ef62c8d7608017508e6e95dc2d8` |
| `measurements/logcat_issues.txt` | 0 | Filtered log (empty means no issues) | P-4 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| `measurements/logcat_since.txt` | 19 | Log window start | P-4 | `69bf63890d6dff99a49f07f8fc05da7b01d6b6c624a8f44589451d2e3f17a5ad` |
| `measurements/snap.sh` | 852 | Settings snapshot helper | Method, P-3 | `895213fa9520b876572f54a0180ab1488222d1eb6ac0c52b05989bab420d5978` |
| `screenshots/A0_open.png` | 184,113 | Screenshot | A-1 | `9524815ecf58b24c07dde62aac0865c6179bfb6cc39926a842a5f70481c23030` |
| `screenshots/A1_wrong.png` | 179,470 | Screenshot | A-3 | `0d78566222d9e71e263a67e9661452cce7c8795b799d293194d46d9a2b7845ac` |
| `screenshots/A2_reentry.png` | 186,142 | Screenshot | A-5 | `74bb033a1aa31344560371bae3880acb85bf7cca21c9daeab32d5b8b30de1132` |
| `screenshots/F0_open.png` | 116,629 | Screenshot | F-1 | `abfe6a96e3e372f6d97f916f15db56e91184490a903f297544f77aa016137faa` |
| `screenshots/F1_wrong.png` | 123,610 | Screenshot | F-2 | `5e0303efb63c2ea5d2647837d05e83a781431ba30aeb149f1d84b710a5ad4ca8` |
| `screenshots/F2_notready.png` | 124,231 | Screenshot | F-3 | `17db5e2126fd6c6520303b32d7e7c111727caf459f0f854d2bf01f39c1fb2218` |
| `screenshots/F2b_notice.png` | 124,231 | Screenshot | F-3 (scrolled: no notice, button disabled) | `17db5e2126fd6c6520303b32d7e7c111727caf459f0f854d2bf01f39c1fb2218` |
| `screenshots/F3_unequal.png` | 187,444 | Screenshot | F-4 | `a0a726d193b591ed319ad3c501d1907f0e642183dd5d4fcbc181e2406ee9d8f9` |
| `screenshots/F4_equal.png` | 127,045 | Screenshot | F-4 follow-up (fair deal) | `731fd5785acb08cc0b39bed38c8ac594a012fba6e679efd5a6e4112aad1d37db` |
| `screenshots/F5_take.png` | 98,926 | Screenshot | F-5 (take step) | `8586f341fe758cddfc42c7c1ee6d2b87b10212662c1d810a9c7770771c68d77d` |
| `screenshots/F6_take2.png` | 118,528 | Screenshot | F-5 | `c09f56ac3fb6e27d2c6d1405d5e447fdd0a7e25abbfc57df4f716d18ffd4b768` |
| `screenshots/F7_result.png` | 128,367 | Screenshot | F-6 | `58e4a8b8c517d6d3372fadf190469b3c4caa5923f7fb7266d7c35b0a2fdb1de0` |
| `screenshots/F8_item2.png` | 91,597 | Screenshot | F-7 (item opened) | `3b530ac9d406bdfed8c2c4a0d8ab42dff354388ae75e34969f6adbb9e313086b` |
| `screenshots/F9_correct.png` | 129,962 | Screenshot | F-7 | `f7d8e2b2b2f259fc8131927b7a70c4d7ce4292d4ad18a26e98bd3380e4f6a4ce` |
| `screenshots/L0_angle.png` | 156,605 | Screenshot | R-2 | `63a0e092f4130f45c04c8ef219580bc72c1b5dd06068bbb9b156cf40139b1a6d` |
| `screenshots/L1_angle_matched.png` | 147,852 | Screenshot | R-2 | `32313d325bd1fbbbbf2ae3c838a92fc89b84a78bd9d074a8e26432fa9212b4f5` |
| `screenshots/L2_fractions.png` | 111,389 | Screenshot | R-3 | `9afabe3dc37f6b55cfbff1b8e6502791f7a35ad0d89a3bcab9b6625ed37b464c` |
| `screenshots/L3_fractions_result.png` | 92,107 | Screenshot | R-3 | `dfa83952ed6d246255f1d189e39014626dc550134e1f0b4c1ddcea01e5d60d90` |
| `screenshots/P1_home.png` | 290,467 | Screenshot | Preflight: first launch after install | `db456a8a57724e28e595b4c0780a32de6a512143d6527ef6ec28eca9e736f1d3` |
| `screenshots/RM_off.png` | 169,768 | Screenshot | P-3 (in-app settings restored) | `0ca4071a90c60de05025f755562166f874c248d23e682094eb3055aff25e7f3a` |
| `screenshots/RM_on.png` | 169,967 | Screenshot | R-6 (settings on) | `e38f6a86428045b6cbb5991792f0fbcf998dbbc5785798d42b12bbb7743053d0` |
| `screenshots/S1_binomial_rm.png` | 211,750 | Screenshot | R-6 | `462c5c4ebb3492f5a969e1c55489e26f54743bd331489d5c22d131ea7afdad6e` |
| `screenshots/S2_binomial_pulled.png` | 241,393 | Screenshot | R-6 | `e5006326c56cf3555b506d9e0bfc553853954cae4f23745c221058a210ee65ae` |
| `screenshots/S3_panda_garden_rm.png` | 887,002 | Screenshot | R-6 | `302ec6b7abdf6d5a63057223fc4423e77e8c7b27eda22a6ea18f575ea143f40a` |
| `screenshots/S4_panda_portions_rm.png` | 656,553 | Screenshot | R-6 | `dfd324f3690e3eb4fccc4197f8271a6bad43e68ec778ec2c90684cee7fe005a4` |
| `screenshots/T0_frac_large.png` | 111,601 | Screenshot | R-4 / observation 2 (system font 2.0, app text unscaled) | `6c50111cdb48924a5116c8ba42cf477d759772d23eabb57499ca7fb063ea2119` |
| `screenshots/T1_frac_large_open.png` | 122,467 | Screenshot | R-4 | `0859e121638fc95f9610f1a70c7001dc66aaad4c36f36fcb893a3b050526c6e2` |
| `screenshots/T2_frac_large_result.png` | 112,765 | Screenshot | R-4 | `4eb1cc1b45d55a7439da80cc4732a340953e717b80b8ecb427bb0d6bc8d1b041` |
| `screenshots/T3_angle_large_matched.png` | 225,388 | Screenshot | R-4 | `7764814d00af409516102715f37489409f2f8a5728af3894fcdc83d03a34ad66` |
| `screenshots/TL_large_setting.png` | 195,111 | Screenshot | R-4 (Reading Size Large) | `c0105389f8589f6481c400c4747788bd2c7c4cc8f6642291439d2f41fb0e284e` |
| `screenshots/V6_landscape_matched.png` | 156,882 | Screenshot | R-2 (before scrolling to Check) | `8ce0e4a7777a64aabd51684f430466d41c9188fd8862d742d8caf9c1b1b0f1ad` |
| `screenshots/V6_large_text_matched.png` | 190,920 | Screenshot | R-4 | `fc280384e9e75708c3aa1ddb388bbba851bf88055de1330ab4d9bc3193591936` |
| `screenshots/V6_portrait_matched.png` | 177,078 | Screenshot | A-4 | `0e467ab0ad4cc6f112a56cd8f7cb190a0ddccab4452d521b1c867c17e9d93505` |
| `screenshots/V6_rm_quiet_matched.png` | 177,472 | Screenshot | R-6 | `157031c398ef71db1719b9d05dab7433e231ccca1e4b37d2d3b9829d1a02dea4` |
| `screenshots/Z_final_home.png` | 292,649 | Screenshot | Final device state | `88495fb420e29e95c041b13de2ee969160d1f53fe3198368735031500c901a2a` |

## Kept outside Git (15 files)

These files are stored on the QA workstation only, at `D:\AI\Quantumlab\apps\edex\qa_evidence_private\PANDA_BINOMIAL_ANGLE_2026-11-22\`.

- The full logcat is a phone-wide system log, including account-related lines from other apps.
- The preference snapshots contain the learner's local data, including an account-scope token.
- The raw framebuffers are about 10 MB each.

Keep the folder access-controlled. Do not commit, upload or share it.

| File | Bytes | Capture type | Scenario | SHA-256 |
|---|---|---|---|---|
| `learner_data/prefs_after.xml` | 2,951 | Learner preferences snapshot | P-2 | `6a1c1c3a46255cf1009494279ca79daeb5ed8a968dc7d7184ee9fb57b48ac898` |
| `learner_data/prefs_before.xml` | 2,798 | Learner preferences snapshot | P-2 | `e86e632c02a6e79fccef6dc9cc126368544b27a342beb61deb02da4d1c151a8d` |
| `logs/logcat_full.txt` | 2,846,839 | Full device logcat (system-wide) | P-4 | `9f45051df5ff383822d60e1538a1ba8357795f4a56abc21278132634142c616f` |
| `raw_framebuffers/raw_a.bin` | 10,368,016 | Raw framebuffer (screencap) | R-4 (last aim 0 capture) | `fd84c1bfc7be75034ec31f8ed8057663b9c772a00542bf64ed909a994d6c8d4f` |
| `raw_framebuffers/raw_b.bin` | 10,368,016 | Raw framebuffer (screencap) | R-4 (last aim 29 capture) | `c47e8c8f1261c6a1b2869cb34157bd6b348b9cc9fd1695c934b0d8e8150cc425` |
| `raw_framebuffers/raw_c30.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `2fa9fdda8b151dc10679b27ae35ffec7fc9e3e7863e1d9ed58a58a1092d222e0` |
| `raw_framebuffers/raw_p30.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `2fa9fdda8b151dc10679b27ae35ffec7fc9e3e7863e1d9ed58a58a1092d222e0` |
| `raw_framebuffers/raw_p60.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `17670396b206a38188dd8f7d61f649f7a37162147f2539ce517bf1ab16d3887e` |
| `raw_framebuffers/raw_post.bin` | 10,368,016 | Raw framebuffer (screencap) | A-3 | `7d985454652a830add1a360ce151dda7783c7c6b2cbfedd897ff75fbb507e696` |
| `raw_framebuffers/raw_pre.bin` | 10,368,016 | Raw framebuffer (screencap) | A-3 | `9ac8d186078463b9eb1143807c654a41e212d1d06683cc7850e992b0e261220f` |
| `raw_framebuffers/raw_re.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `01afa44707ccb8fefcb50ebee963d17189a230e21dd6a1751f1882d3b0db3021` |
| `raw_framebuffers/raw_rf.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `01afa44707ccb8fefcb50ebee963d17189a230e21dd6a1751f1882d3b0db3021` |
| `raw_framebuffers/raw_u45.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `d18912a148c705215d954ef27903dfac7ac770df17285eed14f884ab7c792a02` |
| `raw_framebuffers/raw_u60.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `17670396b206a38188dd8f7d61f649f7a37162147f2539ce517bf1ab16d3887e` |
| `raw_framebuffers/raw_u90.bin` | 10,368,016 | Raw framebuffer (screencap) | A-5 | `c1b2eb215a792b877878cfaaa9db8d397fe91a255321202b8d9ae77bdbd360d3` |

## Not preserved

- **Per-step uiautomator dumps.** The capture helper overwrote one `ui.xml` file on every step. The only full-tree label listings kept are `accessibility/A0_labels.txt` and `accessibility/F0_labels.txt`. Other tree observations quoted in the report were read from the live dump at the time; they are not stored as files. This covers F-3 `enabled="false"`, the R-5 Back targets and the P-1 foreground checks.
- **Installed APKs.** `before/installed.apk` (`7f2a4ade…9d84`) and the candidate pulled from the device (`741abb06…2309`) were not copied. The candidate can be rebuilt from commit `4494356`. Its hash, signer and size are in the report.
- **Device log from 05:09 to 05:12:52.** The device's log buffer had already overwritten it before capture (report, Defects 3).
