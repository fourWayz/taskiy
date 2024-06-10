// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "./IZKShuffle.sol"; // Interface for zkShuffle

contract ShuffleManager {
    IZKShuffle public zkShuffle;
    uint256 public shuffleId;

    constructor(IZKShuffle _zkShuffle) {
        zkShuffle = _zkShuffle;
    }

    function createShuffle(uint256 players) external returns (uint256) {
        shuffleId = zkShuffle.createShuffleGame(players);
        return shuffleId;
    }

    function shuffle(uint256 gameId, bytes calldata next) external {
        zkShuffle.shuffle(gameId, next);
    }

    function dealCardsTo(uint256 gameId, uint256[] calldata cardIds, uint256 playerId, bytes calldata next) external {
        zkShuffle.dealCardsTo(gameId, cardIds, playerId, next);
    }

    function openCards(uint256 gameId, uint256 playerId, uint256[] calldata cardIds, bytes calldata next) external {
        zkShuffle.openCards(gameId, playerId, cardIds, next);
    }

    function endGame(uint256 gameId) external {
        zkShuffle.endGame(gameId);
    }
}
