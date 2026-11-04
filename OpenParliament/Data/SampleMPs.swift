//
//  SampleMPs.swift
//  OpenParliament
//

import Foundation

extension SampleData {

    static let mps: [MP] = [
        MP(
            id: "mp-raghavan",
            name: "Ananya Raghavan",
            constituency: "Thiruvananthapuram",
            state: "Kerala",
            party: .unitedDemocratic,
            house: .lokSabha,
            firstElected: 2014,
            committees: [
                "Standing Committee on Health & Family Welfare",
                "Public Accounts Committee"
            ],
            questionsAsked: 214,
            attendanceHistory: Fixture.attendance([94, 88, 91, 96, 89, 93, 95]),
            engagements: [
                BillEngagement(billID: "bill-health", role: .sponsor),
                BillEngagement(billID: "bill-dpdp", role: .committeeMember),
                BillEngagement(billID: "bill-water", role: .debated)
            ]
        ),
        MP(
            id: "mp-deshpande",
            name: "Vikram Deshpande",
            constituency: "Pune",
            state: "Maharashtra",
            party: .nationalProgressive,
            house: .lokSabha,
            firstElected: 2019,
            committees: ["Standing Committee on Energy"],
            questionsAsked: 138,
            attendanceHistory: Fixture.attendance([82, 74, 79, 71, 84, 77, 80]),
            engagements: [
                BillEngagement(billID: "bill-grid", role: .sponsor),
                BillEngagement(billID: "bill-water", role: .debated)
            ]
        ),
        MP(
            id: "mp-bhattacharya",
            name: "Meera Bhattacharya",
            constituency: "Bardhaman–Durgapur",
            state: "West Bengal",
            party: .regionalPeoples,
            house: .lokSabha,
            firstElected: 2009,
            committees: [
                "Standing Committee on Water Resources",
                "Committee on Estimates"
            ],
            questionsAsked: 301,
            attendanceHistory: Fixture.attendance([88, 90, 83, 87, 81, 86, 84]),
            engagements: [
                BillEngagement(billID: "bill-water", role: .sponsor),
                BillEngagement(billID: "bill-health", role: .committeeMember)
            ]
        ),
        MP(
            id: "mp-siddiqui",
            name: "Iqbal Siddiqui",
            constituency: "Jodhpur",
            state: "Rajasthan",
            party: .nationalProgressive,
            house: .lokSabha,
            firstElected: 2019,
            committees: ["Standing Committee on Rural Development"],
            questionsAsked: 92,
            attendanceHistory: Fixture.attendance([71, 62, 58, 66, 69, 61, 64]),
            engagements: [
                BillEngagement(billID: "bill-grid", role: .coSponsor),
                BillEngagement(billID: "bill-health", role: .debated),
                BillEngagement(billID: "bill-dpdp", role: .debated)
            ]
        ),
        MP(
            id: "mp-norbu",
            name: "Tenzin Norbu",
            constituency: "Gangtok",
            state: "Sikkim",
            party: .independent,
            house: .lokSabha,
            firstElected: 2021,
            committees: ["Committee on Public Undertakings"],
            questionsAsked: 118,
            attendanceHistory: Fixture.attendance([66, 73, 75, 70, 78, 72, 74]),
            engagements: [
                BillEngagement(billID: "bill-water", role: .debated),
                BillEngagement(billID: "bill-grid", role: .debated)
            ]
        ),
        MP(
            id: "mp-iyer",
            name: "Lakshmi Iyer",
            constituency: "Coimbatore",
            state: "Tamil Nadu",
            party: .janhitMorcha,
            house: .lokSabha,
            firstElected: 2014,
            committees: [
                "Standing Committee on Information Technology",
                "Committee on Subordinate Legislation"
            ],
            questionsAsked: 265,
            attendanceHistory: Fixture.attendance([90, 86, 92, 84, 88, 91, 87]),
            engagements: [
                BillEngagement(billID: "bill-dpdp", role: .sponsor),
                BillEngagement(billID: "bill-health", role: .debated),
                BillEngagement(billID: "bill-grid", role: .committeeMember)
            ]
        )
    ]
}
