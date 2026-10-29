# NSHealth

A small iOS app that loads a haematology lab report (FHIR R4 `DiagnosticReport`) from the public HL7 example server and displays it.

## Requirements

- Xcode 27 (built and tested with 27.0)
- iOS 18.0 or later
- An internet connection (the report is fetched live)

## Setup

1. Clone the repo and open `NSHealth.xcodeproj`.
2. Xcode resolves the one Swift package dependency, [FHIRModels](https://github.com/apple/FHIRModels) (0.9.3), automatically.
3. Select the `NSHealth` scheme and an iPhone simulator, then run (⌘R).
4. Run the tests with ⌘U.

## Features

- A simple splash screen. The launch screen is configured in `Info.plist` (`UILaunchScreen`: background colour + logo), and `SplashView` shows the same colour and logo for a second before the tabs appear.
- Two tabs, **Home** and **Report**. The layout follows what the API returns rather than copying the example UI:
  1. **Home** shows only the **latest** report: name, date and lab; and counts of tests, out-of-range and normal results. "Open report" opens that report's detail on the Report tab, with the list behind it.
  2. **Report list** (Report tab): one row per `DiagnosticReport` in the response, newest first, with category, status, name, date, lab and the number of out-of-range results.
  3. **Report detail** (tap a row), for the selected report:
     - A header with the Haematology and Final tags, Test Performer, Collected and Issued times, and the report number.
     - Results in two sections: **Blood count** and **White cell differential**.
  4. **Result detail** (tap a result): value, flag, normal range, the full LOINC test name and code, performer and collection time.
- **Paired results.** The lab reports each white cell type twice under the same name, once as a percentage and once as an absolute count. They're shown as one row instead of two identical-looking ones. The pairing comes from the data (same name, one value in %), not from a hard-coded list.
- Each result shows its value with unit, the normal range and a Normal/Low/High flag.
- Loading, error (offline/server/unreadable) and retry states, plus pull to refresh.
- Works offline after the first load: responses are kept in a `URLCache`, and if the request fails because there's no connection or it times out (30 s), the last saved response is shown.
- Light and dark mode, following the system setting. Every colour in the asset catalog has a light and a dark variant, so the app switches automatically.
- Localised with a String Catalog: English and Hindi, including plural rules.

The app uses MVVM with a service layer. `LabReportsViewModel` is created once and shared by both tabs, and it talks to `ReportService` through a protocol. The service gets the data from `APIClient` and passes it to `FHIRReportParser`, the only place that uses the FHIRModels R4 types; it maps them into small app models. Navigation is handled in `RootTabView` with one `NavigationStack` per tab. Code is grouped by feature under `Modules/`, with shared networking, views and theme under `Shared/`.

## Assumptions

- The response can contain more than one `DiagnosticReport`. All of them are listed, newest first, and Home shows the latest. The sample response has one.
- The response is decoded with the R4 models (`ModelsR4`), as the assignment asks, even though the URL is on `build.fhir.org`.
- When an Observation has no `interpretation`, the flag is worked out from the value and the reference range.
- Only `valueQuantity` results are shown, since every result in the sample is numeric. Results without a reference range show "No reference range provided".
- Dates are shown in the lab's own time zone, so the sample always reads 4 March 2011, 08:30.
- The `Patient` isn't included in the response, so no patient details are shown.
