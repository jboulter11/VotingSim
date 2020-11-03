struct Candidate {
    typealias Id = String
    var id: Id
    var name: String
    var party: Party
    var stances: [Issue.Id:Stance]
}

typealias Position = Int

struct Stance {
    var issueId: Issue.Id
    var position: Position
}

struct Issue {
    typealias Id = String
    var id: Id
    var name: String
}

struct Voter {
    typealias Id = String
    var id: String
    var stances: [Stance]
}

struct Vote {
    var voterId: Voter.Id
    var electionId: Election.Id
    var candidateId: Candidate.Id
}

struct Election {
    typealias Id = Int
    var id:Id
    var candidates: [Candidate.Id:Candidate]
    var voters: [Voter]
}

struct ElectionResult: CustomDebugStringConvertible {
    var election: Election
    var winner: Candidate.Id
    var tally: [Candidate.Id:Int]
    var votes: [Vote]
    
    var debugDescription: String {
        var output =
            """
            Election \(election.id)
            Winner: \(election.candidates[winner]?.name ?? "ERROR")
            Turnout: \(votes.count) votes
            Tally:
            ---------------------

            """
        for row in tally.sorted(by: { $0.value > $1.value }) {
            let name = election.candidates[row.key]?.name ?? "ERROR"
            output.append("\(name) | \(row.value)\n")
        }
        return output
    }
}

enum Party {
    case democrat
    case republican
}

struct Government {
    var elections: [Election]
    var voters: [Voter]
    var candidates: [Candidate.Id:Candidate]
    var currentPresidentId: Candidate.Id?
    var legislation: Legislation
    
    var currentPresident: Candidate? {
        guard let currentPresidentId = currentPresidentId else {
            return nil
        }
        return candidates[currentPresidentId]
    }
}

struct Legislation {
    var stances: [Issue.Id:Stance]
}

typealias Tally = [Candidate.Id:Int]
