// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract Lotto {
    uint256 MAX_NUMBER = 1000000;
    mapping(address => uint256[]) lottos;

    function newLotto(address buyer,uint256 _number)external {
        lottos[buyer].push(_number);
    }
}
