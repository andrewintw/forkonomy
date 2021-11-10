// SPDX-License-Identifier: Forkonomy()

// 2021-11-10, draft Rev1

pragma solidity >=0.8.0 <0.9.0;

// 南海共管合約
contract NaiHaiCoOpt {
    enum ManagementMethod { Co_opt, Private_Own, State_Own, Own_by_Others, Other } // 和約管理型態，但目前都是共管
    ManagementMethod mng_type = ManagementMethod.Co_opt;
    
    uint maxOceanID = 100;          // 限制最多可以賣幾份海水
    uint pricePerMl = 12150 gwei;   // 目前行情: 0.000012150 ETH = 12150 gwei = 12150000000000 wei = 1.6 TWD (2021-11-10)
    uint reservedOceanId = 0;       // // 目前賣了幾份, 每賣出一份 +1
    string codeConduct = "https://hackmd.io/Z_JSJYc_Qeamk1-rvvRfMQ"; // 行為準則，指向一份文件 URL
    address contractOwner;

    // 描述可被交易的南海海水
    struct QueerOcean {
        address ownerAddress;   // 該區域的目前 owner
        uint volume;            // 容量(ml)
        uint lastPrice;         // 最近一次成交價
        uint lastTransTime;     // 最近一次交易時間
    }

    mapping(uint => QueerOcean) oceanContract; // 每個 Ocean ID 對應一區南海海水

    // 決定初始價格
    constructor(uint _price) {
        contractOwner = msg.sender;
        pricePerMl = _price;
    }

    // 查詢合約總覽
    function contactSummary() external view 
        returns (uint _balance, uint _maxOceanID, uint _currOcenID, uint _price, ManagementMethod _mngType, string memory _conduct) {
        _balance    = address(this).balance;    // 查詢合約內的總金額
        _maxOceanID = maxOceanID;
        _currOcenID = reservedOceanId;
        _price      = pricePerMl;
        _mngType    = mng_type;
        _conduct    = codeConduct;
    }

    // 更新買賣屬性
    function setContactProperties(uint _maxOceanID, uint _newPrice) external {
        maxOceanID = _maxOceanID;
        pricePerMl = _newPrice;
    }
    
    // 買入操作
    function reserveOcean() external payable {
        require(msg.value >= pricePerMl, "ERROR: Not enough money!");
        require(reservedOceanId <= (maxOceanID - 1), "WARN: Sold Out.");

        reservedOceanId++;
        oceanContract[reservedOceanId].ownerAddress = msg.sender;
        oceanContract[reservedOceanId].volume = msg.value / pricePerMl; // 不找零喔 XD
        oceanContract[reservedOceanId].lastPrice = msg.value;
        oceanContract[reservedOceanId].lastTransTime = block.timestamp;
    }

    // 替換某個 ocean ID 的 owner
    function transferOcean(uint _oceanId) external payable {
        address _seller = oceanContract[_oceanId].ownerAddress; // seller is OLD owner
        oceanContract[_oceanId].ownerAddress = msg.sender;      // buyer is NEW owenr
        oceanContract[_oceanId].lastPrice = msg.value;
        // payable(_seller).transfer(msg.value); // 透過合約轉錢給原始的 owner
        payable(_seller).transfer((msg.value * 98) / 100); // 抽 2% 手續 XD
        oceanContract[reservedOceanId].lastTransTime = block.timestamp;
    }

    // 輸入 oceanID 查詢那區海水的資訊
    function oceanTransInfo(uint _oceanId) external view 
        returns (uint _oceanid, address _owner, uint _volume, uint _price, uint _time) {
        _oceanid = _oceanId;
        _owner   = oceanContract[_oceanId].ownerAddress;
        _volume  = oceanContract[_oceanId].volume;
        _price   = oceanContract[_oceanId].lastPrice;
        _time    = oceanContract[_oceanId].lastTransTime;
    }

    // 還是需要有個 function 讓你把錢從合約取出來
    function withdraw(address payable _addr, uint256 _amount) external {
        require(msg.sender == contractOwner, "ERROR: permission denied!");
        require(_amount <= address(this).balance, "ERROR: balance is not enough!");
        _addr.transfer(_amount);
    }
}


// Online ABI Encoding: https://abi.hashex.org/
