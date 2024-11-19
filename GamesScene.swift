import SpriteKit

class GameScene: SKScene {
    weak var graffitiGameController: FirstGame?
    
    let graffitiGridSize = 5
    var graffitiTileSize: CGFloat = 65
    let graffitiTileImages: [String] = ["Graffiti1", "Graffiti2", "Graffiti3", "Graffiti4", "Graffiti5"]
    
    var graffitiGrid: [[GraffitiTileNode?]] = []
    var graffitiSelectedTile: GraffitiTileNode?
    var movesLabel: SKLabelNode!
    var graffitiMovesLeft = 0
    var totalGraffitiMovesLeft = 0
    var graffitiScore = 0
    
    override func didMove(to view: SKView) {
        graffitiMovesLeft = totalGraffitiMovesLeft
        setupGraffitiBackground()
        setupGraffitiGameBackground()
        setupGraffitiGrid()
        setupMovesLabel()
        scheduleGraffitiMatchCheck()
    }
    
    func setupGraffitiBackground() {
        let graffitiBackground = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "graffitiSelectedImageName") ?? "BG")
        let scaleX = size.width / graffitiBackground.size.width
        let scaleY = size.height / graffitiBackground.size.height
        graffitiBackground.setScale(max(scaleX, scaleY))
        graffitiBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        graffitiBackground.zPosition = -2
        addChild(graffitiBackground)
    }
    
    func setupGraffitiGameBackground() {
        let graffitiGameBackground = SKSpriteNode(imageNamed: "BG2")
        let backgroundWidth = CGFloat(graffitiGridSize) * graffitiTileSize
        let backgroundHeight = CGFloat(graffitiGridSize) * graffitiTileSize
        let scaleX = backgroundWidth / graffitiGameBackground.size.width
        let scaleY = backgroundHeight / graffitiGameBackground.size.height
        graffitiGameBackground.setScale(max(scaleX, scaleY))
        graffitiGameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        graffitiGameBackground.zPosition = -1
        addChild(graffitiGameBackground)
    }

    func setupGraffitiGrid() {
        graffitiTileSize = 55
        graffitiGrid = Array(repeating: Array(repeating: nil, count: graffitiGridSize), count: graffitiGridSize)
        fillGraffitiGridWithoutMatches()
    }
    
    func fillGraffitiGridWithoutMatches() {
        removeAllGraffitiTiles()
        var isValid = false
        while !isValid {
            isValid = true
            for row in 0..<graffitiGridSize {
                for col in 0..<graffitiGridSize {
                    let imageName = graffitiTileImages.randomElement()!
                    let newTile = GraffitiTileNode(imageNamed: imageName)
                    newTile.row = row
                    newTile.col = col
                    newTile.size = CGSize(width: graffitiTileSize, height: graffitiTileSize)
                    newTile.position = graffitiPositionFor(row: row, col: col)
                    newTile.setScale(1)
                    addChild(newTile)
                    graffitiGrid[row][col] = newTile
                }
            }
            
            if checkForGraffitiMatches() {
                removeAllGraffitiTiles()
                isValid = false
            }
        }
    }
    
    func checkForGraffitiMatches() -> Bool {
        var hasMatches = false
        for row in 0..<graffitiGridSize {
            for col in 0..<graffitiGridSize - 2 {
                if let tile1 = graffitiGrid[row][col], let tile2 = graffitiGrid[row][col + 1], let tile3 = graffitiGrid[row][col + 2] {
                    if tile1.imageName == tile2.imageName && tile1.imageName == tile3.imageName {
                        hasMatches = true
                    }
                }
            }
        }
        
        for col in 0..<graffitiGridSize {
            for row in 0..<graffitiGridSize - 2 {
                if let tile1 = graffitiGrid[row][col], let tile2 = graffitiGrid[row + 1][col], let tile3 = graffitiGrid[row + 2][col] {
                    if tile1.imageName == tile2.imageName && tile1.imageName == tile3.imageName {
                        hasMatches = true
                    }
                }
            }
        }
        
        return hasMatches
    }
    
    func removeAllGraffitiTiles() {
        for row in 0..<graffitiGridSize {
            for col in 0..<graffitiGridSize {
                if let tile = graffitiGrid[row][col] {
                    tile.removeFromParent()
                    graffitiGrid[row][col] = nil
                }
            }
        }
    }

    func handleGraffitiTileSelection(_ tile: GraffitiTileNode) {
        if isPaused || graffitiMovesLeft <= 0 { return }
        bottleSound()
        if let selectedTile = graffitiSelectedTile {
            if selectedTile == tile {
                selectedTile.deselect()
                graffitiSelectedTile = nil
                return
            }
            
            if isValidGraffitiMove(selectedTile: selectedTile, newRow: tile.row, newCol: tile.col) {
                swapGraffitiTiles(tile1: selectedTile, row: tile.row, col: tile.col)
                selectedTile.deselect()
                graffitiSelectedTile = nil
                checkAndRemoveGraffitiMatches()
                graffitiMovesLeft -= 1
                updateMovesLabel()
            } else {
                selectedTile.deselect()
                tile.select()
                graffitiSelectedTile = tile
            }
        } else {
            tile.select()
            graffitiSelectedTile = tile
        }
    }
    
    func isValidGraffitiMove(selectedTile: GraffitiTileNode, newRow: Int, newCol: Int) -> Bool {
        return abs(selectedTile.row - newRow) + abs(selectedTile.col - newCol) == 1
    }
    
    func graffitiPositionFor(row: Int, col: Int) -> CGPoint {
        let offsetX = (size.width - CGFloat(graffitiGridSize) * graffitiTileSize) / 2
        let offsetY = (size.height - CGFloat(graffitiGridSize) * graffitiTileSize) / 2
        return CGPoint(
            x: offsetX + CGFloat(col) * graffitiTileSize + graffitiTileSize / 2,
            y: offsetY + CGFloat(row) * graffitiTileSize + graffitiTileSize / 2
        )
    }
    
    func swapGraffitiTiles(tile1: GraffitiTileNode, row: Int, col: Int) {
        let tile2 = graffitiGrid[row][col]
        
        graffitiGrid[tile1.row][tile1.col] = tile2
        graffitiGrid[row][col] = tile1
        
        tile2?.row = tile1.row
        tile2?.col = tile1.col
        tile1.row = row
        tile1.col = col
        
        let tile1Pos = graffitiPositionFor(row: row, col: col)
        let tile2Pos = graffitiPositionFor(row: tile2!.row, col: tile2!.col)
        
        tile1.run(SKAction.move(to: tile1Pos, duration: 0.2))
        tile2?.run(SKAction.move(to: tile2Pos, duration: 0.2))
    }
    
    func checkAndRemoveGraffitiMatches() {
        var hasMatches = true

        while hasMatches {
            var tilesToRemove = Set<GraffitiTileNode>()
            hasMatches = false

            for row in 0..<graffitiGridSize {
                for col in 0..<graffitiGridSize - 2 {
                    if let tile1 = graffitiGrid[row][col],
                       let tile2 = graffitiGrid[row][col + 1],
                       let tile3 = graffitiGrid[row][col + 2],
                       tile1.imageName == tile2.imageName,
                       tile1.imageName == tile3.imageName {
                        tilesToRemove.insert(tile1)
                        tilesToRemove.insert(tile2)
                        tilesToRemove.insert(tile3)
                        hasMatches = true
                    }
                }
            }

            for col in 0..<graffitiGridSize {
                for row in 0..<graffitiGridSize - 2 {
                    if let tile1 = graffitiGrid[row][col],
                       let tile2 = graffitiGrid[row + 1][col],
                       let tile3 = graffitiGrid[row + 2][col],
                       tile1.imageName == tile2.imageName,
                       tile1.imageName == tile3.imageName {
                        tilesToRemove.insert(tile1)
                        tilesToRemove.insert(tile2)
                        tilesToRemove.insert(tile3)
                        hasMatches = true
                    }
                }
            }

            if hasMatches {
                for tile in tilesToRemove {
                    removeGraffitiTile(tile)
                }
                
                let waitAction = SKAction.wait(forDuration: 0.3)
                run(waitAction) {
                    self.refillGraffitiGrid()
                }
            }
        }
        
        if graffitiMovesLeft <= 0 && graffitiScore >= totalGraffitiMovesLeft*3 {
            graffitiGameController?.graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: true)
        } else if  graffitiMovesLeft <= 0{
            graffitiGameController?.graffitiEndGame(graffitiScore: graffitiScore, graffitiIsWin: false)
        }
    }

    func removeGraffitiTile(_ tile: GraffitiTileNode) {
        graffitiGrid[tile.row][tile.col] = nil
        graffitiGameController?.graffitiUpdateScore()
        if  totalGraffitiMovesLeft == 30{
            graffitiScore+=1
        } else if totalGraffitiMovesLeft == 20 {
            graffitiScore+=2
        } else {
            graffitiScore+=3
        }
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
        let removeAction = SKAction.removeFromParent()
        tile.run(SKAction.sequence([fadeOutAction, removeAction]))
    }

    func refillGraffitiGrid() {
        for col in 0..<graffitiGridSize {
            var emptyRows: [Int] = []
            
            for row in 0..<graffitiGridSize {
                if graffitiGrid[row][col] == nil {
                    emptyRows.append(row)
                }
            }
            
            for emptyRow in emptyRows {
                let imageName = graffitiTileImages.randomElement()!
                let newTile = GraffitiTileNode(imageNamed: imageName)
                newTile.row = emptyRow
                newTile.col = col
                newTile.size = CGSize(width: graffitiTileSize, height: graffitiTileSize)
                newTile.position = graffitiPositionFor(row: emptyRow, col: col)
                
                addChild(newTile)
                graffitiGrid[emptyRow][col] = newTile
            }
        }
        
        let waitAction = SKAction.wait(forDuration: 0.2)
        run(waitAction) {
            self.checkAndRemoveGraffitiMatches()
        }
    }
    
    func scheduleGraffitiMatchCheck() {
        let graffitiMatchCheckAction = SKAction.run {
            self.checkAndRemoveGraffitiMatches()
        }
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let sequenceAction = SKAction.sequence([graffitiMatchCheckAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction)
    }
    
    func pauseGraffitiGame() {
        isPaused = true
        self.isPaused = true
    }
    
    func resumeGraffitiGame() {
        isPaused = false
        self.isPaused = false
    }
    
    func restartGraffitiGame() {
        graffitiMovesLeft = totalGraffitiMovesLeft
        graffitiScore = 0
        updateMovesLabel()
    }
    
    func setupMovesLabel() {
        movesLabel = SKLabelNode(fontNamed: "Questrian")
        movesLabel.fontSize = 40
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: size.width / 2, y: size.height*0.75)
        movesLabel.text = "\(graffitiMovesLeft)"
        addChild(movesLabel)
    }
    
    func updateMovesLabel() {
        movesLabel.text = "\(graffitiMovesLeft)"
    }
}

class GraffitiTileNode: SKSpriteNode {
    var row: Int = 0
    var col: Int = 0
    var isSelected: Bool = false
    var imageName: String
    
    init(imageNamed name: String) {
        self.imageName = name
        super.init(texture: SKTexture(imageNamed: name), color: .clear, size: CGSize(width: 50, height: 50))
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        self.isSelected = true
        self.alpha = 0.6
    }
    
    func deselect() {
        self.isSelected = false
        self.alpha = 1.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = self.scene as? GameScene else { return }
        scene.handleGraffitiTileSelection(self)
    }
}
