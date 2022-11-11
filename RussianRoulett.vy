players: public(DynArray[address, 100])
losers: public(DynArray[address, 100])
odds: public(uint256)
playersTurn: public(uint256)
creator: public(address)
currentRandomNum: public(uint256)
newArray: public(DynArray[address, 100])

@external
def __init__():
    self.creator = msg.sender
    self.players = []
    self.losers = []
    self.odds = 5
    self.playersTurn = 0
    self.currentRandomNum = 123321

@external
def setOdds(oneInThisMany: uint256):
    if msg.sender==self.creator:
        self.odds = oneInThisMany

@internal
def contains(array: DynArray[address,100], player: address) -> bool:
    for _player in array:
        if player==_player:
            return True
    return False

@internal
def remove(array: DynArray[address,100], player: address) -> DynArray[address,100]:
    self.newArray = []
    for _player in array:
        if not _player == player:
            self.newArray.append(_player)
    return self.newArray



@external
def addPlayer(player: address):
    assert not self.contains(self.players, player)
    assert not self.contains(self.losers, player)
    self.players.append(player)

@internal
def lose(player: address):
    self.losers.append(player)
    self.players = self.remove(self.players, player)

#generating a random number by multiplying by a prime, modding by a prime, then modding by odds to get it within range
@internal
def random() -> uint256:
    return (((self.currentRandomNum * 7121)%5527)%self.odds)

@external
def play():
    self.currentRandomNum = self.random()
    if self.currentRandomNum == 1:
        self.playersTurn=self.playersTurn+1
    else:
        self.lose(self.players[self.playersTurn])

@external
def isALoser(player: address) -> bool:
    return self.contains(self.losers, player)
