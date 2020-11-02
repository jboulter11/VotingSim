class VoteDecider {
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
