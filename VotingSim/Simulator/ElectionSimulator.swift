class ElectionSimulator {
    let voteDecider: VoteDecider
    
    init(voteDecider: VoteDecider) {
        self.voteDecider = voteDecider
    }
    
    func run(election: Election) -> ElectionResult {
        let votes = election.voters.map { voter in
            voteDecider.decide(voter: voter, in: election)
        }
        
        let tally = self.tally(votes: votes, in: election)
        let winner = decideWinner(from: tally, in: election)
        
        return ElectionResult(election: election,
                              winner: winner,
                              tally: tally,
                              votes: votes
        )
    }
    
    
    
    func tally(votes: [Vote], in election: Election) -> Tally {
        var tally = Tally()
        for candidate in election.candidates.values {
            tally[candidate.id] = 0
        }
        for vote in votes {
            tally[vote.candidateId] = (tally[vote.candidateId] ?? 0) + 1
        }
        return tally
    }
    
    func decideWinner(from tally: Tally, in election: Election) -> Candidate.Id {
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
        return winner
    }
}
