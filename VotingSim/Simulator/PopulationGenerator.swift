class PopulationGenerator {
    let candidates = [
        Candidate(id: "0",
                  name: "Dolan Termp",
                  party: .republican,
                  stances: [
                    "i0": Stance(issueId: "i0",
                           position: -100
                    ),
                    "i1": Stance(issueId: "i1",
                           position: -100
                    ),
                    "i2": Stance(issueId: "i2",
                           position: -100
                    ),
                  ]
        ),
        Candidate(id: "1",
                  name: "Mutt Rimney",
                  party: .republican,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: -100
                      ),
                      "i1": Stance(issueId: "i1",
                             position: -100
                      ),
                      "i2": Stance(issueId: "i2",
                             position: 50
                      ),
                  ]
        ),
        Candidate(id: "2",
                  name: "Jopef Bidet",
                  party: .democrat,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: 80
                      ),
                      "i1": Stance(issueId: "i1",
                             position: 50
                      ),
                      "i2": Stance(issueId: "i2",
                             position: 60
                      ),
                  ]
        ),
        Candidate(id: "3",
                  name: "Parak Obana",
                  party: .democrat,
                  stances: [
                      "i0": Stance(issueId: "i0",
                             position: 85
                      ),
                      "i1": Stance(issueId: "i1",
                             position: 50
                      ),
                      "i2": Stance(issueId: "i2",
                             position: 65
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
        var stances = [Stance]()
        for i in 0..<issues.count {
            let randomPosition = Position.random(in: -100...100, using: &randomGenerator)
            stances.append(Stance(issueId: "i\(i)", position: randomPosition))
        }
        return stances
    }
}
