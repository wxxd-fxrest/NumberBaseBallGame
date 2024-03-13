import Foundation

class BaseBallGameClass {
    // 정답을 저장하는 프로퍼티 -> 저장 프로퍼티
    // private: 비공개 접근 수준, 클래스 내부에서만 접근할 수 있도록 private 접근 제한자로 선언
    // 외부에서 직접적으로 이 프로퍼티에 접근할 수 없고, 클래스 내부 메서드를 통해서만 프로퍼티에 접근할 수 있음
    private var answer: [Int] = []
    
    // 게임 기록 구조체
    struct GameRecord {
        let gameNumber: Int
        let attemptsCount: Int
    }
    
    // 게임 기록 배열
    private var records: [GameRecord] = []
    
    // 현재 게임 횟수
    private var currentGameNumber: Int = 0

    // 초기화 및 게임 시작
    init() {
        startGame()
    }
    
    // 게임 시작 메서드
    private func startGame() {
        currentGameNumber += 1
        print("환영합니다! 번호를 입력해주세요.")
        print("1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기")
        
        if let input = readLine(), let choice = Int(input) {
            switch choice {
            case 1:
                print("게임 \(currentGameNumber)을 시작합니다!")
                generateAnswer()
                playGame()
            case 2:
                print("게임 기록을 보여줍니다!")
                showRecords()
                startGame() // 다시 게임 시작 메뉴로 이동
            case 3:
                print("게임을 종료합니다.")
                records = [] // records 배열을 빈 배열로 초기화
                startGame() // 다시 게임 시작 메뉴로 이동
            default:
                print("잘못된 입력입니다. 다시 시도해주세요.")
                startGame() // 다시 게임 시작 메뉴로 이동
            }
        } else {
            print("숫자를 입력해주세요.")
            startGame() // 다시 게임 시작 메뉴로 이동
        }
    }
    
    // 정답 생성 메서드
    private func generateAnswer() {
        var numbers = Set<Int>()
        // numbers라는 이름의 빈 Set을 선언 :: Set => 정수형(Int) 요소를 가지는 집합
        
        // while 루프를 사용하여 numbers의 요소 개수가 3보다 작을 때까지 반복
        while numbers.count < 3 {
            // 반복할 때마다 0부터 9까지의 임의의 숫자를 생성하여 randomNumber에 저장합
            var randomNumber = Int.random(in: 0...9)
            
            // 첫 번째 숫자인 경우, 1부터 8까지의 범위에서 임의의 숫자를 생성하여 삽입
            if numbers.isEmpty {
                randomNumber = Int.random(in: 1...9)
           }
            numbers.insert(randomNumber)
            // 생성된 임의의 숫자를 numbers에 삽입
        }

        answer = Array(numbers)
        // numbers의 요소 개수가 3이 되면, 이를 answer 배열에 저장

        print(answer)
    }

    // 게임 플레이 메서드
    private func playGame() {
        var attemptsCount = 0 // 플레이 횟수를 기록하기 위한 변수
        while true {
            attemptsCount += 1
            print("3개의 숫자를 입력하세요. 각 숫자는 띄어쓰기로 구분해주세요.")
            guard let input = readLine() else {
                print("입력이 없습니다.")
                continue
            }
            let numbers = input.split(separator: " ").compactMap { Int($0) }
            guard numbers.count == 3 else {
                print("숫자 3개를 입력해주세요.")
                continue
            }

            // strike와 ball 변수 초기화
            var strike = 0
            var ball = 0

            
            // 사용자가 입력한 숫자 배열 check를 순회하면서 각 숫자를 정답과 비교
            // enumerated()를 사용하여 숫자 배열의 각 요소와 인덱스를 가져옴
            // 각 숫자, 정답을 같은 인덱스에 있는 숫자와 비교하여 스트라이크인지, 볼인지, 아웃인지 확인
            // enumerated: 시퀀스(Sequence)를 순회하면서 각 요소와 해당 요소의 인덱스를 튜플 형태로 반환하는 메서드, for-in루프와 함께 사용되어 각 요소와 해당 요소의 인덱스에 접근할 수 있도록 도와줌
            for (index, number) in numbers.enumerated() {
                if number == answer[index] {
                    strike += 1
                } else if answer.contains(number) {
                    ball += 1
                }
            }

            if strike == 3 {
                recordGame(attempts: attemptsCount)
                print("정답입니다!")
                break // 정답을 맞추면 게임 종료
            } else {
                print("\(strike) 스트라이크, \(ball) 볼입니다.")
                // 틀린 경우 기록에 저장
                if attemptsCount == 10 {
                    recordGame(attempts: attemptsCount)
                    print("10번의 시도 동안 정답을 맞추지 못했습니다. 게임 종료.")
                    break
                }
            }
        }
        startGame() // 다시 게임 시작 메뉴로 이동
    }
    
    // 게임 기록 메서드
    private func recordGame(attempts: Int) {
        let record = GameRecord(gameNumber: currentGameNumber, attemptsCount: attempts)
        records.append(record)
    }

    // 게임 기록 출력 메서드
    private func showRecords() {
        if records.isEmpty {
            print("아직 기록이 없습니다.")
        } else {
            print("< 게임 기록 보기 >")
            for record in records {
                print("\(record.gameNumber)번째 게임 : 시도 횟수 - \(record.attemptsCount)")
            }
        }
    }
}

// 게임 시작
let game = BaseBallGameClass()
