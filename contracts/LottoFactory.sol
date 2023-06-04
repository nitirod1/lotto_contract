// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./LottoToken.sol";

contract LottoFactory {
    uint256 MAX_NUMBER = 1000000;
    uint256 MIN_NUMBER = 99999;
    address ADMIN ;
    address CONTROLLER ;

    LottoToken lottoToken ;
     // address to installment to number
    mapping(address =>  mapping(uint256 => uint256[])) walletLotto;
    // address to installment to number mapping to tokenId
    mapping (address => mapping(uint256 => mapping(uint256 => uint256))) walletTokenId;
   
    // Installment to MAX_NUMBER reward
    mapping(uint256 => uint256) reward1;
    
    mapping(uint256 => uint256[]) reward2;
    mapping(uint256 => uint256[]) reward3;
    mapping(uint256 => uint256[]) reward4;
    mapping(uint256 => uint256[]) reward5;
    string [5] rewardMessage = ["1", "2", "3", "4", "5"];

    constructor(){
        ADMIN = msg.sender;
        CONTROLLER = msg.sender;
    }
    
    event BuyLotto(address user, uint256 balance);
    
    modifier IsAdmin(){
        require(msg.sender == ADMIN);
        _;
    }

    modifier IsController(){
        require(msg.sender == ADMIN || msg.sender == CONTROLLER);
        _;
    }

    function setController(address _controller)external IsAdmin(){
        CONTROLLER = _controller;
    }

    function setLottoAddress(address _address) external IsAdmin(){
        lottoToken = LottoToken(_address);
    }

    function getReward(uint256 _installment)public view returns(uint256, uint256 []memory,uint256 []memory,uint256 []memory,uint256 []memory){
        return (reward1[_installment],reward2[_installment],reward3[_installment],reward4[_installment],reward5[_installment]);
    }

    function getWalletLotto(address _owner,uint256 _installment)public view returns(uint256[]memory){
        return walletLotto[_owner][_installment];
    }

    function getWalletTokenId(address _owner , uint256 _installment,uint256 _number)public view returns(uint256){
        return walletTokenId[_owner][_installment][_number];
    }

    function ranReward1(uint256 _installment)external IsController(){
        uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,msg.sender))) % MAX_NUMBER;
        reward1[_installment] = reward;
    }
    
    function ranReward2(uint256 _installment)external IsController(){
        for(uint256 i=0;i<5;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,msg.sender))) % MAX_NUMBER;
            reward2[_installment].push(reward);
        }
    }
    
    function ranReward3(uint256 _installment)external IsController(){
        for(uint256 i=0;i<5;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,msg.sender))) % MAX_NUMBER;
            reward3[_installment].push(reward);
        }
    }

    function ranReward4(uint256 _installment)external IsController(){
        for(uint256 i=0;i<5;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,msg.sender))) % MAX_NUMBER;
            reward4[_installment].push(reward);
        }
    }

    function ranReward5(uint256 _installment)external IsController(){
        for(uint256 i=0;i<5;i++){
            uint256 reward = uint256(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,msg.sender))) % MAX_NUMBER;
            reward5[_installment].push(reward);
        }
    }

    function buyLotto(address _buyer,uint256 _installment, uint256 _number , string memory _uri) external payable {
        require(msg.value >=1000000 gwei);
        require(MAX_NUMBER >_number && MIN_NUMBER <_number);
        uint256 tokenId = lottoToken.safeMint(_buyer, _uri);
        walletLotto[_buyer][_installment].push(_number);
        walletTokenId[_buyer][_installment][_number] = tokenId;
    }

    function checkReward(address _owner,uint256 _installment,uint256 _number)public view returns(string memory){
        uint256 tokenId = walletTokenId[_owner][_installment][_number] ;
        if(lottoToken.ownerOf(tokenId) == _owner) {
            if (_number == reward1[_installment]){
                return "1";
            }
            for(uint256 i =0;i<reward2[_installment].length;i++){
                if (_number == reward2[_installment][i]){
                    return"2";
                }
            }
            for(uint256 i =0;i<reward3[_installment].length;i++){
                if (_number == reward3[_installment][i]){
                    return "3";
                }
            }
            for(uint256 i =0;i<reward4[_installment].length;i++){
                if (_number == reward4[_installment][i]){
                    return "4";
                }
            }
            for(uint256 i =0;i<reward5[_installment].length;i++){
                if (_number == reward5[_installment][i]){
                    return "5";
                }
            }
            return "0";
        }else{
            return "not owner";
        }
    }

    receive() external payable {
        emit BuyLotto(msg.sender, msg.value);
    }
}
