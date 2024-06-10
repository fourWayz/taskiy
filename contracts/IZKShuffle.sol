// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface IZKShuffle {
    function createShuffleGame(uint256 players) external returns (uint256);
    function shuffle(uint256 gameId, bytes calldata next) external;
    function dealCardsTo(uint256 gameId, uint256[] calldata cardIds, uint256 playerId, bytes calldata next) external;
    function openCards(uint256 gameId, uint256 playerId, uint256[] calldata cardIds, bytes calldata next) external;
    function endGame(uint256 gameId) external;
}
