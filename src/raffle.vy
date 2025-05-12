# pragma version 0.4.0
"""
@license MIT
@title Raffle Contract
@author Nested4Loops
@notice Raffle that lets users enter sending ETH and picks a random winner
Raffle contract use flow:
1. Raffle is deployed my owner with a set duration
2. Users join the raffle sending the entrance fee to the contract in eth
3. When a user joins, the time is checked against the duration
3a. If the time is up the raffle is closed and the winner is picked
3b. If the time is not up, the user is added to the entrants list
4. If the raffle is open, anyone can request the winner, which will pick a winner and close the raffle.
"""

ENTRANTS: DynArray[address, 1000] #array of entries as addresses
ENTRANCE_FEE: public(constant(uint256)) = as_wei_value(0.01, "ether")
COLLECTED_ENTRANCE_FEES: DynArray[uint256, 1000] #Individual fees collected
TOTAL_POT: public(uint256) #Sum of all entrance fees
RAFFLE_OPEN: public(bool)
OWNER: public(immutable(address))
RAFFLE_DURATION: public(uint256) #Raffle duration seconds
RAFFLE_END: public(uint256)
WINNER: public(address)

@deploy
def __init__(_raffle_duration: uint256):
    OWNER = msg.sender
    self.RAFFLE_DURATION = _raffle_duration #Deploy with a 30 day duration
    self._run_raffle(self.RAFFLE_DURATION)

    
@external
@payable
def enter_raffle():
    """ 
    Participants enter the raffle here by sending their entrance fee in ETH.  
    Participants may enter more than one time, their address will be added to the list.
    Max entrants is 1000
    """
    assert self.RAFFLE_OPEN, "The raffle is closed, try again next time"
    assert msg.value == ENTRANCE_FEE, "Your entrance fee is incorrect"
    self.ENTRANTS.append(msg.sender)
    self.COLLECTED_ENTRANCE_FEES.append(msg.value)
    self.TOTAL_POT += msg.value
        

@external
def run_raffle(DURATION: uint256) -> String[50]:
    assert msg.sender == OWNER, "Only the raffle owner can start a new raffle"
    return self._run_raffle(DURATION)

@internal  
def _run_raffle(DURATION: uint256) -> String[50]:
    assert self.RAFFLE_OPEN == False, "Raffle is already running"
    self.RAFFLE_END = block.timestamp + (DURATION)
    raffle_start_confirmation: String[20] = "Raffle is running"
    self.RAFFLE_OPEN = True
    self.ENTRANTS = []
    self.COLLECTED_ENTRANCE_FEES = []
    self.TOTAL_POT = 0
    return raffle_start_confirmation


@external
def pick_winner():
    """
    Pick a random winner
    """
    assert self.RAFFLE_OPEN, "Raffle is closed, please try again next time"
    assert block.timestamp >= self.RAFFLE_END, "Raffle time is not up yet"
    self._pick_winner()

@internal
def _pick_winner() -> address:
    #Pick random winner by finding a random index in the list of entrants
    #-> IMPLEMENT CHAINLINK VRF HERE
    
    #Send pot to winner less fees

    #Close raffle
    self.WINNER = self.ENTRANTS[0] #PLACEHOLDER
    self.RAFFLE_OPEN = False
    return self.WINNER

    