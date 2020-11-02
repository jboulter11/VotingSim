class Simulator {
    
    var randomGenerator: SeededRandomNumberGenerator
    let populationGenerator: PopulationGenerator
    let electionSimulator: ElectionSimulator
    
    init() {
        self.randomGenerator = SeededRandomNumberGenerator(seed: 132534342412312214)
        self.populationGenerator = PopulationGenerator(randomGenerator: randomGenerator)
        self.electionSimulator = ElectionSimulator(voteDecider: VoteDecider())
    }
    
    // N parties [Done]
    // Each Candidate has a Stance on an Issue [Done]
    // Each Voter has a Stance on all Issues [Done]
    // Stances can be Positive, Neutral, or Negative [Done]
    // Each Voter casts a Vote in the Election [Done]
    // Each Voter can perfectly see each Candidate's Stances [Done]
    // At the end, the winning Candidate takes office
    // The Candidate enacts a change to the current state of the Government, in the form of +/- change to a Stance's current status
    // Repeat
    //
    // Ideas:
    // Voters have an income, gender, race, etc assigned based off realistic distributions and use that to build stances using probability
    // Media's affect on voters
    // Later issues can be linked or associated somehow politically
    // Maybe strong and weak pos/neg positions later
    // Multiple elections later
    // Obscurity of information on candidate's stance later
    // VP
    func run() {
        let voters = populationGenerator.generateVoters(count: 1000)
        
        let candidateIdPairs = populationGenerator.candidates.map { ($0.id, $0) }
        let candidatesMap = Dictionary(uniqueKeysWithValues: candidateIdPairs)
        
        let issueStancePairs = populationGenerator.issues.values.map {
            ($0.id, Stance(issueId: $0.id, position: .neutral))
        }
        let stancesMap = Dictionary(uniqueKeysWithValues: issueStancePairs)
        let legislation = Legislation(stances: stancesMap)
        
        var government = Government(elections: [],
                                    voters: voters,
                                    candidates: candidatesMap,
                                    currentPresidentId: nil,
                                    legislation: legislation)
        
        for electionId in stride(from: 2020, to: 2025, by: 4) {
            let election = Election(id: electionId,
                                    candidates: government.candidates,
                                    voters: government.voters)
            let result = electionSimulator.run(election: election)
            print(result)
            
            government.currentPresidentId = result.winner
            
            let maxStance = government.currentPresident?.stances.max(by: { pairA, pairB -> Bool in
                if pairA.value.position == pairB.value.position {
                    if let issueAName = populationGenerator.issues[pairA.key]?.name,
                       let issueBName = populationGenerator.issues[pairB.key]?.name {
                        return issueAName < issueBName
                    }
                }
                return abs(pairA.value.position.rawValue) < abs(pairB.value.position.rawValue)
            })
            
            guard let presidentStance = maxStance else {
                preconditionFailure("Can't get top stance for current president \n\(government.currentPresident)")
            }
            let signum = presidentStance.value.position.rawValue.signum()
            guard let positionToModify = government.legislation.stances[presidentStance.key]?.position else {
                preconditionFailure("Can't find position to modify")
            }
            // TODO: Probably make position just a typealiased Int
            guard let newPosition = Position(rawValue: positionToModify.rawValue + signum) else {
                preconditionFailure("Can't make new position with given raw value")
            }
            
            government.legislation.stances[presidentStance.key]?.position = newPosition
        }
    }
}
