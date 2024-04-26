import React
import JavaScriptKit
import SRTDOM

// https://ja.react.dev/learn/tutorial-tic-tac-toe

func addCSS(path: String) throws {
    let document = JSWindow.global.document

    let head = try document.querySelector("head").unwrap("head")

    let tag = try document.createElement("link")
    try tag.setAttribute("rel", "stylesheet")
    try tag.setAttribute("type", "text/css")
    try tag.setAttribute("href", "/" + path)
    try head.appendChild(tag)
}

func calculateWinner(squares: [String?]) -> String? {
    let lines: [[Int]] = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    for line in lines {
        let (a, b, c) = (line[0], line[1], line[2])

        if let x = squares[a],
           squares[b] == x,
           squares[c] == x {
            return x
        }
    }
    return nil
}

struct Square: Component {
    var value: String?
    var onSquareClick: EventListener

    func render() -> Node {
        return button(
            attributes: ["class": "square"],
            listeners: ["click": onSquareClick]
        ) {
            value
        }
    }
}

struct Board: Component {
    var xIsNext: Bool = true
    var squares: [String?] = Array(repeating: nil, count: 9)
    var onPlay: Function<Void, [String?]>

    func handleClick(index: Int) {
        if squares[index] != nil ||
            calculateWinner(squares: squares) != nil { return }

        var squares = self.squares

        if xIsNext {
            squares[index] = "X"
        } else {
            squares[index] = "O"
        }

        onPlay(squares)
    }

    func render() -> Node {
        let winner = calculateWinner(squares: squares)
        let status: String
        if let winner {
            status = "Winner: " + winner;
        } else {
            status = "Next player: " + (xIsNext ? "X" : "O")
        }

        return Fragment {
            div(attributes: ["class": "status"]) { status }
            div(attributes: ["class": "board-row"]) {
                Square(value: squares[0], onSquareClick: EventListener { (_) in handleClick(index: 0) })
                Square(value: squares[1], onSquareClick: EventListener { (_) in handleClick(index: 1) })
                Square(value: squares[2], onSquareClick: EventListener { (_) in handleClick(index: 2) })
            }
            div(attributes: ["class": "board-row"]) {
                Square(value: squares[3], onSquareClick: EventListener { (_) in handleClick(index: 3) })
                Square(value: squares[4], onSquareClick: EventListener { (_) in handleClick(index: 4) })
                Square(value: squares[5], onSquareClick: EventListener { (_) in handleClick(index: 5) })
            }
            div(attributes: ["class": "board-row"]) {
                Square(value: squares[6], onSquareClick: EventListener { (_) in handleClick(index: 6) })
                Square(value: squares[7], onSquareClick: EventListener { (_) in handleClick(index: 7) })
                Square(value: squares[8], onSquareClick: EventListener { (_) in handleClick(index: 8) })
            }
        }
    }
}

struct Game: Component {
    @State var history: [[String?]] = [Array(repeating: nil, count: 9)]
    @State var currentMove: Int = 0

    func render() -> Node {
        let xIsNext = currentMove % 2 == 0

        let currentSquares = history[currentMove]

        let handlePlay = Function<Void, [String?]> { (nextSquares) in
            history = history[...currentMove] + [nextSquares]
            currentMove = history.count - 1
        }

        func jumpTo(nextMove: Int) {
            currentMove = nextMove
        }

        let moves: [Node] = history.enumerated().map { (move, squares) -> Node in
            let description: String
            if move > 0 {
                description = "Go to move #\(move)"
            } else {
                description = "Go to game start"
            }
            return li(key: move) {
                button(listeners: ["click": EventListener { (e) in jumpTo(nextMove: move) }]) {
                    description
                }
            }
        }

        return div(attributes: ["class": "game"]) {
            div(attributes: ["class": "game-board"]) {
                Board(xIsNext: xIsNext, squares: currentSquares, onPlay: handlePlay)
            }
            div(attributes: ["class": "game-info"]) {
                ol {
                    moves
                }
            }
        }
    }
}

try addCSS(path: "TicTacToe_TicTacToe.resources/styles.css")

let body = try JSWindow.global.document.body.unwrap("body")
let root = ReactRoot(element: body)
root.render(node: Game())
