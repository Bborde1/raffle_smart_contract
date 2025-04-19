# pragma version 0.4.0
"""
@license MIT
@title Raffle Contract
@author Nested4Loops
@notice Raffle that lets users enter sending ETH and picks a random winner
"""

ENTRANTS: DynArray[address, 1000]
MIN_ENTRANCE_FEE: public(constant(uint256)) = as_wei_value(0.01, "ether")
COLLECTED_ENTRANCE_FEES: DynArray[uint256, 1000]
TOTAL_POT: public(uint256)
RAFFLE_OPEN: public(bool)
OWNER: public(address)

@deploy
def __init__():
    self.RAFFLE_OPEN = True
    self.OWNER = msg.sender


    
@external
@payable
def enter_raffle():
    """ 
    Participants enter the raffle here by sending their entrance fee in ETH.  
    Participants may enter more than one time, their address will be added to the list.
    Max entrants is 1000
    """
    assert self.RAFFLE_OPEN, "The raffle is closed, try again next time"
    assert msg.value >= MIN_ENTRANCE_FEE, "Your entrance fee is too low"
    self.ENTRANTS.append(msg.sender)
    self.COLLECTED_ENTRANCE_FEES.append(msg.value)
    self.TOTAL_POT += msg.value
        

@external
def pick_winner():
    #Pick random winner by finding a random index in the list of entrants
    #-> IMPLEMENT CHAINLINK VRF HERE
    #Close raffle
    self.RAFFLE_OPEN = False
    