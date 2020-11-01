class Simulator {
    
    var randomGenerator: SeededRandomNumberGenerator
    let populationGenerator: PopulationGenerator
    
    init() {
        self.randomGenerator = SeededRandomNumberGenerator(seed: 132534342412312214)
        self.populationGenerator = PopulationGenerator(randomGenerator: randomGenerator)
    }
    
    // N parties
    // Each Candidate has a Stance on an Issue
    // Each Voter has a Stance on all Issues
    // (Later issues can be linked or associated somehow politically)
    // Stances can be Positive, Neutral, or Negative (maybe strong and weak pos/neg later)
    // Each Voter casts a Vote in the Election (multiple elections later)
    // Each Voter can perfectly see each Candidate's Stances (obscurity later)
    // At the end, the winning Candidate takes office
    // The Candidate enacts a change to the current state of the world, in the form of +/- change to a Stance's current status
    // Repeat
    func run() {
        let voters = populationGenerator.generateVoters(count: 1000)
        let candidateIdPairs = populationGenerator.candidates.map { ($0.id, $0) }
        let candidatesMap = Dictionary(uniqueKeysWithValues: candidateIdPairs)
        let election = Election(id: 0, candidates: candidatesMap, voters: voters)
        let result = run(election: election)
        print(result)
    }
    
    func run(election: Election) -> ElectionResult {
        let votes = election.voters.map { voter in
            decide(voter: voter, in: election)
        }
        
        var tally = [Candidate.Id:Int]()
        for candidate in election.candidates.values {
            tally[candidate.id] = 0
        }
        for vote in votes {
            tally[vote.candidateId] = (tally[vote.candidateId] ?? 0) + 1
        }
        
        let topCandidate = tally.max { (pairA, pairB) -> Bool in
            if pairA.value == pairB.value {
                guard let cA = election.candidates[pairA.key],
                      let cB = election.candidates[pairB.key] else {
                    preconditionFailure("Candidates not in election during decision")
                }
                return cA.name < cB.name
            }
            return pairA.value < pairB.value
        }
        guard let winner = topCandidate?.key else {
            preconditionFailure("Can't pick winner")
        }
        return ElectionResult(election: election,
                              winner: winner,
                              tally: tally,
                              votes: votes
        )
    }
    
    func decide(voter: Voter, in election: Election) -> Vote {
        let candidates = Array(election.candidates.values)
        let weights = calculateOpinions(of: candidates, for: voter)
        
        let bestMatch = weights.max { pairA, pairB -> Bool in
            if pairA.value == pairB.value {
                guard let cA = election.candidates[pairA.key],
                      let cB = election.candidates[pairB.key] else {
                    preconditionFailure("Candidates not in election during decision")
                }
                return cA.name < cB.name
            }
            return pairA.value < pairB.value
        }
        
        guard let decidedCandidate = bestMatch?.key else {
            preconditionFailure("Couldn't pick a candidate in election")
        }
        
        return Vote(voterId: voter.id, electionId: election.id, candidateId: decidedCandidate)
    }
    
    func calculateOpinions(of candidates: [Candidate], for voter: Voter) -> [Candidate.Id:Int] {
        var weights = [Candidate.Id:Int]()
        for candidate in candidates {
            weights[candidate.id] = calculateOpinion(of: candidate, for: voter)
        }
        return weights
    }
    
    func calculateOpinion(of candidate: Candidate, for voter: Voter) -> Int {
        var weight = 0
        for voterStance in voter.stances {
            if let candidateStance = candidate.stances[voterStance.issueId] {
                let diffOnIssue = abs(voterStance.position.rawValue - candidateStance.position.rawValue)
                let weightForMatchedStance = abs(voterStance.position.rawValue)
                let weightForThisCandidateOnThisIssue = weightForMatchedStance - diffOnIssue
                weight += weightForThisCandidateOnThisIssue
            }
        }
        return weight
    }
}

struct Candidate {
    typealias Id = String
    var id: Id
    var name: String
    var party: Party
    var stances: [Issue.Id:Stance]
}

enum Position: Int, CaseIterable {
    case positive = 1
    case neutral = 0
    case negative = -1
}

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
            Tally:\n
            """
        for row in tally.sorted(by: { $0.value > $1.value }) {
            let name = election.candidates[row.key]?.name ?? "ERROR"
            output.append("\(name): \(row.value)\n")
        }
        return output
    }
}

enum Party {
    case democrat
    case republican
}

struct World {
    var elections: [Election]
    var voters: [Voter.Id:Voter]
    var candidates: [Candidate.Id:Candidate]
}
