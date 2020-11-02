class PopulationGenerator {
    let candidates = [
        Candidate(id: "0",
                  name: "Dolan Termp",
                  party: .republican,
                  stances: [
                    "i0": Stance(issueId: "i0",
                           position: .negative
                    ),
                    "i1": Stance(issueId: "i1",
                           position: .negative
                    ),
                    "i2": Stance(issueId: "i2",
                           position: .negative
                    ),
                  ]
        ),
        Candidate(id: "1",
                  name: "Mutt Rimney",
                  party: .republican,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: .negative
                      ),
                      "i1": Stance(issueId: "i1",
                             position: .negative
                      ),
                      "i2": Stance(issueId: "i2",
                             position: .positive
                      ),
                  ]
        ),
        Candidate(id: "2",
                  name: "Jopef Bidet",
                  party: .democrat,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: .positive
                      ),
                      "i1": Stance(issueId: "i1",
                             position: .negative
                      ),
                      "i2": Stance(issueId: "i2",
                             position: .positive
                      ),
                  ]
        ),
        Candidate(id: "3",
                  name: "Parak Obana",
                  party: .democrat,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: .positive
                      ),
                      "i1": Stance(issueId: "i1",
                             position: .positive
                      ),
                      "i2": Stance(issueId: "i2",
                             position: .positive
                      ),
                  ]
        ),
    ]
    
    let issues = [
        "i0": Issue(id: "i0",
              name: "Abortion rights"
        ),
        "i1": Issue(id: "i1",
              name: "Climate conservation"
        ),
        "i2": Issue(id: "i2",
              name: "Socialized healthcare"
        ),
    ]
    
    var randomGenerator: SeededRandomNumberGenerator
    init(randomGenerator: SeededRandomNumberGenerator) {
        self.randomGenerator = randomGenerator
    }
    
    func generateVoters(count: Int) -> [Voter] {
        var voters = [Voter]()
        for i in 0..<count {
            voters.append(
                Voter(id: "\(i)",
                      stances: generateStances()
                )
            )
        }
        return voters
    }
    
    func generateStances() -> [Stance] {
        issues.values.map { issue in
            guard let randomPosition = Position.allCases.randomElement(using: &randomGenerator) else {
                preconditionFailure("Should never be unable to get a random position")
            }
            return Stance(issueId: issue.id, position: randomPosition)
        }
    }
}
