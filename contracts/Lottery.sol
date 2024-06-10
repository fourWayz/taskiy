// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "./ShuffleManager.sol";

contract Lottery {
    ShuffleManager public shuffleManager;
    uint256 public ticketPrice;
    address[] public players;
    uint256 public shuffleId;
    mapping(address => uint256) public playerIndices;

    event TicketPurchased(address indexed player, uint256 indexed playerIndex);
    event WinnerSelected(address indexed winner, uint256 prizeAmount);

    constructor(ShuffleManager _shuffleManager, uint256 _ticketPrice) {
        shuffleManager = _shuffleManager;
        ticketPrice = _ticketPrice;
    }

    function buyTicket() external payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");
        players.push(msg.sender);
        uint256 playerIndex = players.length - 1;
        playerIndices[msg.sender] = playerIndex;
        emit TicketPurchased(msg.sender, playerIndex);
    }

    function startShuffle() external {
        require(players.length > 1, "Not enough players");
        shuffleId = shuffleManager.createShuffle(players.length);
        bytes memory next = abi.encodeWithSelector(this.dealCards.selector);
        shuffleManager.shuffle(shuffleId, next);
    }

    function dealCards() external {
        uint256[] memory cardIds = new uint256[](players.length);
        for (uint256 i = 0; i < players.length; i++) {
            cardIds[i] = i;
        }
        bytes memory next = abi.encodeWithSelector(this.openCards.selector);
        shuffleManager.dealCardsTo(shuffleId, cardIds, 0, next);
    }

    function openCards() external {
        uint256[] memory cardIds = new uint256[](1);
        cardIds[0] = 0;
        bytes memory next = abi.encodeWithSelector(this.endGame.selector);
        shuffleManager.openCards(shuffleId, 0, cardIds, next);
    }

    function endGame() external {
        shuffleManager.endGame(shuffleId);
        selectWinner();
    }

    function selectWinner() internal {
        uint256 winningIndex = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % players.length;
        address winner = players[winningIndex];
        uint256 prizeAmount = address(this).balance;
        payable(winner).transfer(prizeAmount);
        emit WinnerSelected(winner, prizeAmount);
        resetLottery();
    }

    function resetLottery() internal {
        delete players;
    }
}
