-- Generated from the app's bundled fixtures (OpenParliament/Data). Do not edit by hand;
-- run Server/tools/generate-seed.sh instead so the app's offline data and the database stay identical.

BEGIN;

INSERT INTO parties (abbreviation, name) VALUES
    ('NPP', 'National Progressive Party'),
    ('UDF', 'United Democratic Front'),
    ('RPP', 'Regional People''s Party'),
    ('JM', 'Janhit Morcha'),
    ('IND', 'Independent');

INSERT INTO parliament_sessions (ordinal, name, short_label) VALUES
    (1, 'Budget 2022', '22B'),
    (2, 'Monsoon 2022', '22M'),
    (3, 'Winter 2022', '22W'),
    (4, 'Budget 2023', '23B'),
    (5, 'Monsoon 2023', '23M'),
    (6, 'Winter 2023', '23W'),
    (7, 'Budget 2024', '24B');

INSERT INTO ministries (name) VALUES
    ('Ministry of Electronics & Information Technology'),
    ('Ministry of Jal Shakti'),
    ('Ministry of Health & Family Welfare'),
    ('Ministry of Power');

INSERT INTO committees (name) VALUES
    ('Standing Committee on Health & Family Welfare'),
    ('Public Accounts Committee'),
    ('Standing Committee on Energy'),
    ('Standing Committee on Water Resources'),
    ('Committee on Estimates'),
    ('Standing Committee on Rural Development'),
    ('Committee on Public Undertakings'),
    ('Standing Committee on Information Technology'),
    ('Committee on Subordinate Legislation');

INSERT INTO mps (id, name, constituency, state, party_abbreviation, house, first_elected, questions_asked) VALUES
    ('mp-raghavan', 'Ananya Raghavan', 'Thiruvananthapuram', 'Kerala', 'UDF', 'lok_sabha', 2014, 214),
    ('mp-deshpande', 'Vikram Deshpande', 'Pune', 'Maharashtra', 'NPP', 'lok_sabha', 2019, 138),
    ('mp-bhattacharya', 'Meera Bhattacharya', 'Bardhaman–Durgapur', 'West Bengal', 'RPP', 'lok_sabha', 2009, 301),
    ('mp-siddiqui', 'Iqbal Siddiqui', 'Jodhpur', 'Rajasthan', 'NPP', 'lok_sabha', 2019, 92),
    ('mp-norbu', 'Tenzin Norbu', 'Gangtok', 'Sikkim', 'IND', 'lok_sabha', 2021, 118),
    ('mp-iyer', 'Lakshmi Iyer', 'Coimbatore', 'Tamil Nadu', 'JM', 'lok_sabha', 2014, 265);

INSERT INTO mp_committees (mp_id, committee_id, position) VALUES
    ('mp-raghavan', (SELECT id FROM committees WHERE name = 'Standing Committee on Health & Family Welfare'), 0),
    ('mp-raghavan', (SELECT id FROM committees WHERE name = 'Public Accounts Committee'), 1),
    ('mp-deshpande', (SELECT id FROM committees WHERE name = 'Standing Committee on Energy'), 0),
    ('mp-bhattacharya', (SELECT id FROM committees WHERE name = 'Standing Committee on Water Resources'), 0),
    ('mp-bhattacharya', (SELECT id FROM committees WHERE name = 'Committee on Estimates'), 1),
    ('mp-siddiqui', (SELECT id FROM committees WHERE name = 'Standing Committee on Rural Development'), 0),
    ('mp-norbu', (SELECT id FROM committees WHERE name = 'Committee on Public Undertakings'), 0),
    ('mp-iyer', (SELECT id FROM committees WHERE name = 'Standing Committee on Information Technology'), 0),
    ('mp-iyer', (SELECT id FROM committees WHERE name = 'Committee on Subordinate Legislation'), 1);

INSERT INTO attendance_records (mp_id, session_id, attendance_percent) VALUES
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 94.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 88.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 91.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 96.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 89.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 93.00),
    ('mp-raghavan', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 95.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 82.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 74.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 79.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 71.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 84.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 77.00),
    ('mp-deshpande', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 80.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 88.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 90.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 83.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 87.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 81.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 86.00),
    ('mp-bhattacharya', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 84.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 71.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 62.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 58.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 66.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 69.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 61.00),
    ('mp-siddiqui', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 64.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 66.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 73.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 75.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 70.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 78.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 72.00),
    ('mp-norbu', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 74.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2022'), 90.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2022'), 86.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2022'), 92.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2023'), 84.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Monsoon 2023'), 88.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Winter 2023'), 91.00),
    ('mp-iyer', (SELECT id FROM parliament_sessions WHERE name = 'Budget 2024'), 87.00);

INSERT INTO bills (id, title, bill_number, house, ministry_id, stage, summary) VALUES
    ('bill-dpdp', 'Digital Personal Data Protection (Amendment) Bill, 2025', 'Bill No. 118 of 2025', 'lok_sabha', (SELECT id FROM ministries WHERE name = 'Ministry of Electronics & Information Technology'), 'committee', 'Narrows the blanket exemption that lets government agencies process personal data without consent, and requires every such exemption to be notified with reasons. Also creates a licensed "consent manager" role so people can review and withdraw permissions from one place instead of app by app.'),
    ('bill-water', 'National Water Security and River Rejuvenation Bill, 2024', 'Bill No. 74 of 2024', 'rajya_sabha', (SELECT id FROM ministries WHERE name = 'Ministry of Jal Shakti'), 'passed', 'Sets up river basin authorities that plan water use across state lines instead of state by state. Basin plans become binding once notified, and states must publish how much water each sector actually drew against its share every year.'),
    ('bill-health', 'Public Health Infrastructure (Rural Access) Bill, 2023', 'Bill No. 41 of 2023', 'lok_sabha', (SELECT id FROM ministries WHERE name = 'Ministry of Health & Family Welfare'), 'enacted', 'Guarantees a minimum set of diagnostic services within 30 kilometres of every rural habitation, and fixes staffing norms for sub-centres so a facility cannot be counted as functional without the staff to run it.'),
    ('bill-grid', 'Renewable Energy Grid Integration Bill, 2025', 'Bill No. 149 of 2025', 'lok_sabha', (SELECT id FROM ministries WHERE name = 'Ministry of Power'), 'introduced', 'Opens transmission access to independent storage operators and obliges distribution companies to publish curtailment data — how much renewable power they turned away and why — so that grid constraints can be located rather than assumed.');

INSERT INTO bill_key_points (bill_id, position, point) VALUES
    ('bill-dpdp', 0, 'Government exemptions must be notified individually, with stated grounds.'),
    ('bill-dpdp', 1, 'Consent managers are licensed and must offer a single withdrawal screen.'),
    ('bill-dpdp', 2, 'Businesses below a turnover threshold get an 18-month compliance runway.'),
    ('bill-dpdp', 3, 'Penalties are tiered by the volume of records affected, not by company size.'),
    ('bill-water', 0, 'Basin authorities cover eleven interstate river systems.'),
    ('bill-water', 1, 'Annual sectoral drawdown figures must be published within 90 days of year end.'),
    ('bill-water', 2, 'Sewage treatment capacity targets are tied to the release of central funds.'),
    ('bill-water', 3, 'Disputes go to a standing tribunal rather than ad hoc benches.'),
    ('bill-health', 0, 'Twelve diagnostic tests must be available free at district level.'),
    ('bill-health', 1, 'A sub-centre counts as functional only with two resident health workers.'),
    ('bill-health', 2, 'District hospitals report bed occupancy and stock-outs monthly.'),
    ('bill-health', 3, 'Central funding is released in two tranches against verified staffing.'),
    ('bill-grid', 0, 'Storage operators may seek open access on the same terms as generators.'),
    ('bill-grid', 1, 'Curtailment events must be published within seven days, with reasons.'),
    ('bill-grid', 2, 'A central settlement window covers deviation charges for storage.'),
    ('bill-grid', 3, 'State load despatch centres publish forecast accuracy quarterly.');

INSERT INTO bill_stage_events (bill_id, stage, event_date, detail) VALUES
    ('bill-dpdp', 'introduced', '2025-03-11', 'Introduced in the Lok Sabha and taken up for first reading.'),
    ('bill-dpdp', 'committee', '2025-04-02', 'Referred to the Standing Committee on Information Technology.'),
    ('bill-water', 'introduced', '2024-07-22', 'Introduced in the Rajya Sabha.'),
    ('bill-water', 'committee', '2024-08-19', 'Examined by the Standing Committee on Water Resources; 26 amendments proposed.'),
    ('bill-water', 'passed', '2024-12-12', 'Passed by both Houses with 14 committee amendments accepted.'),
    ('bill-health', 'introduced', '2023-02-09', 'Introduced in the Lok Sabha.'),
    ('bill-health', 'committee', '2023-03-06', 'Standing Committee on Health & Family Welfare reported with minor changes.'),
    ('bill-health', 'passed', '2023-07-21', 'Passed by both Houses.'),
    ('bill-health', 'enacted', '2023-08-14', 'Received assent; notified as Act 22 of 2023.'),
    ('bill-grid', 'introduced', '2025-07-28', 'Introduced in the Lok Sabha; first reading concluded.');

INSERT INTO schemes (id, name, sector, ministry_id, summary) VALUES
    ('scheme-health', 'Rural Health Access Mission', 'Health & Family Welfare', (SELECT id FROM ministries WHERE name = 'Ministry of Health & Family Welfare'), 'Funds diagnostic equipment, sub-centre staffing and patient transport in districts identified as underserved. Released to states in two tranches against verified staffing returns.'),
    ('scheme-rivers', 'National River Rejuvenation Programme', 'Water Resources', (SELECT id FROM ministries WHERE name = 'Ministry of Jal Shakti'), 'Capital support for sewage interception and treatment along eleven river stretches, plus monitoring stations that report effluent load to a public dashboard.'),
    ('scheme-grid', 'Grid Modernisation & Storage Fund', 'Power', (SELECT id FROM ministries WHERE name = 'Ministry of Power'), 'Viability gap funding for battery storage co-located with renewable capacity, and upgrades to state load despatch centres for forecasting and scheduling.'),
    ('scheme-dpi', 'Digital Public Infrastructure Fund', 'Electronics & IT', (SELECT id FROM ministries WHERE name = 'Ministry of Electronics & Information Technology'), 'Supports identity, payments and consent infrastructure operated as public utilities, including the grievance redress systems that sit alongside them.');

INSERT INTO fiscal_year_spend (scheme_id, label, full_label, allocation_crore, actual_crore) VALUES
    ('scheme-health', 'FY22', '2021–22', 9800.00, 8240.00),
    ('scheme-health', 'FY23', '2022–23', 11200.00, 9760.00),
    ('scheme-health', 'FY24', '2023–24', 12500.00, 10910.00),
    ('scheme-health', 'FY25', '2024–25', 13000.00, 12180.00),
    ('scheme-rivers', 'FY22', '2021–22', 6400.00, 4980.00),
    ('scheme-rivers', 'FY23', '2022–23', 7100.00, 5320.00),
    ('scheme-rivers', 'FY24', '2023–24', 8200.00, 6050.00),
    ('scheme-rivers', 'FY25', '2024–25', 8800.00, 7240.00),
    ('scheme-grid', 'FY22', '2021–22', 3900.00, 3610.00),
    ('scheme-grid', 'FY23', '2022–23', 4600.00, 4470.00),
    ('scheme-grid', 'FY24', '2023–24', 5400.00, 5180.00),
    ('scheme-grid', 'FY25', '2024–25', 6100.00, 5940.00),
    ('scheme-dpi', 'FY22', '2021–22', 2400.00, 1760.00),
    ('scheme-dpi', 'FY23', '2022–23', 3100.00, 2240.00),
    ('scheme-dpi', 'FY24', '2023–24', 3600.00, 2610.00),
    ('scheme-dpi', 'FY25', '2024–25', 4200.00, 3380.00);

INSERT INTO cag_findings (scheme_id, reference, note) VALUES
    ('scheme-health', 'CAG Report No. 9 of 2025 (Performance Audit), Para 4.7', 'Utilisation certificates for 14 district units were still pending at the close of 2024–25. Audit attributes the gap to delays in releasing the second tranche rather than to a shortfall in sanctioned funds.'),
    ('scheme-rivers', 'CAG Report No. 3 of 2025, Para 2.11', 'Treatment capacity commissioned in 2023–24 stood at 61 per cent of the target in the sanctioned project reports. Audit attributes most of the gap to land acquisition timelines in three states.'),
    ('scheme-dpi', 'CAG Report No. 12 of 2025, Para 5.2', '₹1,180 crore released to two implementing agencies remained unspent in interest-bearing accounts beyond the permitted 90 days. The agencies have since reported the accrued interest back to the consolidated fund.');

INSERT INTO bill_schemes (bill_id, scheme_id) VALUES
    ('bill-dpdp', 'scheme-dpi'),
    ('bill-water', 'scheme-rivers'),
    ('bill-health', 'scheme-health'),
    ('bill-grid', 'scheme-grid');

INSERT INTO bill_engagements (mp_id, bill_id, role) VALUES
    ('mp-raghavan', 'bill-health', 'sponsor'),
    ('mp-raghavan', 'bill-dpdp', 'committee_member'),
    ('mp-raghavan', 'bill-water', 'debated'),
    ('mp-deshpande', 'bill-grid', 'sponsor'),
    ('mp-deshpande', 'bill-water', 'debated'),
    ('mp-bhattacharya', 'bill-water', 'sponsor'),
    ('mp-bhattacharya', 'bill-health', 'committee_member'),
    ('mp-siddiqui', 'bill-grid', 'co_sponsor'),
    ('mp-siddiqui', 'bill-health', 'debated'),
    ('mp-siddiqui', 'bill-dpdp', 'debated'),
    ('mp-norbu', 'bill-water', 'debated'),
    ('mp-norbu', 'bill-grid', 'debated'),
    ('mp-iyer', 'bill-dpdp', 'sponsor'),
    ('mp-iyer', 'bill-health', 'debated'),
    ('mp-iyer', 'bill-grid', 'committee_member');

INSERT INTO speeches (id, mp_id, bill_id, topic, spoken_on, duration_minutes, excerpt) VALUES
    ('sp-01', 'mp-raghavan', 'bill-health', 'Second reading — rural diagnostic coverage', '2023-07-19', 12, 'A facility without a technician is a building, not a diagnostic service. The 30-kilometre guarantee has to be measured in tests actually run.'),
    ('sp-02', 'mp-siddiqui', 'bill-health', 'Staffing norms for sub-centres', '2023-07-19', 7, 'In desert constituencies the two-worker norm is the binding constraint, not equipment. Recruitment cycles must be funded alongside the capital grant.'),
    ('sp-03', 'mp-iyer', 'bill-health', 'Data reporting obligations on district hospitals', '2023-03-02', 9, 'Monthly stock-out reporting is welcome, but the format must be machine readable or the data will sit in scanned PDFs.'),
    ('sp-04', 'mp-bhattacharya', 'bill-health', 'Committee report — equipment procurement', '2023-03-06', 11, 'The committee found identical equipment procured at materially different rates across three states. Rate contracts should be centralised.'),
    ('sp-05', 'mp-bhattacharya', 'bill-water', 'Interstate river boards and state consent', '2024-11-28', 15, 'Binding basin plans are the right instrument, but states need a defined route to seek revision before the plan is notified, not after.'),
    ('sp-06', 'mp-deshpande', 'bill-water', 'Cost recovery for treatment plants', '2024-12-04', 8, 'Municipalities cannot service the capital cost on current tariffs. Either the tariff assumption changes or the grant share does.'),
    ('sp-07', 'mp-norbu', 'bill-water', 'Himalayan catchment protection', '2024-12-04', 6, 'Basin planning that starts at the plains misses where the water comes from. Catchment states should sit on the authority by right.'),
    ('sp-08', 'mp-raghavan', 'bill-water', 'Public reporting of sectoral drawdown', '2024-12-05', 7, 'Ninety days is generous for figures the state already collects monthly. Thirty would be enough.'),
    ('sp-09', 'mp-iyer', 'bill-dpdp', 'Scope of the exemption for state agencies', '2025-04-16', 14, 'An exemption that is notified with reasons can at least be challenged. A blanket one cannot be examined at all.'),
    ('sp-10', 'mp-raghavan', 'bill-dpdp', 'Consent managers and grievance redress', '2025-04-16', 11, 'A single withdrawal screen only helps if the regulator publishes how long withdrawals actually take to take effect.'),
    ('sp-11', 'mp-siddiqui', 'bill-dpdp', 'Compliance burden on small businesses', '2025-05-08', 6, 'An eighteen-month runway means little without a plain-language compliance kit in regional languages.'),
    ('sp-12', 'mp-deshpande', 'bill-grid', 'Open access for storage operators', '2025-08-04', 10, 'Storage is treated as a load when it charges and a generator when it discharges. The settlement window has to recognise both in the same day.'),
    ('sp-13', 'mp-norbu', 'bill-grid', 'Grid resilience in border districts', '2025-08-05', 5, 'Curtailment data is meaningless in districts that are still on a single radial feed. Publish outage duration alongside it.'),
    ('sp-14', 'mp-bhattacharya', NULL, 'Calling attention — coal transport levies', '2025-02-11', 6, 'The levy was introduced as a temporary measure in 2019 and has been extended four times without review.'),
    ('sp-15', 'mp-raghavan', NULL, 'Zero hour — hospital tariff disclosure', '2024-08-06', 4, 'Empanelled hospitals are required to display package rates. Compliance in my constituency is under half.'),
    ('sp-16', 'mp-siddiqui', NULL, 'Short duration discussion — drought relief', '2024-03-19', 9, 'Relief assessed on rainfall alone misses groundwater depletion, which is what actually ends the cropping season here.'),
    ('sp-17', 'mp-iyer', NULL, 'Motion of thanks — digital literacy outlays', '2025-02-04', 13, 'The outlay has risen every year while the trained-and-certified figure has stayed flat. One of those two numbers is not measuring what we think.'),
    ('sp-18', 'mp-deshpande', NULL, 'Zero hour — surplus railway land parcels', '2023-12-12', 3, 'Four parcels identified as surplus in 2018 remain unmonetised and unmaintained.'),
    ('sp-19', 'mp-norbu', NULL, 'Special mention — border road funding', '2024-07-30', 4, 'The sanctioned length and the constructed length have diverged for three consecutive years without an explanation on record.');

COMMIT;
