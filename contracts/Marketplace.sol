// SPDX-LICENCE-Identifier: MIT
pragma solidity ^0.8.4;

//INTERNAL IMPORT FOR NFT OPENZIPLINE

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";


contract Marketplace is ERC721URIStorage{
    using Counters for Counters.Counters;

    Counters.Counters private _tokenIds;
    Counters.Counters private _itemSold;

    uint256 listingPrice =0.0015 ether;

    address payable owner;

    mapping(uint256 => MarketItem) private idMarketItem;

    struct MarketItem{
        uint256 _tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;

    }

    event idMarketItemCreated(
        uint256 indexed _tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    modifier onlyOwner(){
        require(msg.sender == owner,
        "only owner of the marketplace can change the listing price");
    }

    constructor() ERC721("NFT Metaverse Token","MYNFT"){
        owner ==payable(msg.sender);
    }

    function updateListingsPrice(uint256 _ListingPrice) 
    public 
    payable
    onlyOwner{

    }

    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }

    //Let create "CREATE NFT TOKEN FUNCTION"

    function createToken(string memort tokenURI,uint256 price) public payable return(uint256)
    {
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender,newTokenId);
        _setTokenURI(newTokenId,tokenURI);

        createMarketItem(newTokenId,price);

        return newTokenId;
    }

    //CREATING MARKET ITEMS

    function  createMarketItem(uint256 tokenId,uint256 price)private{
        require(price>0,"Price must be atleast 1");
        require(msg.value == listingPrice,"Price must be equal to listing price");

        idMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false,
        );

        _transfer(msg.sender,address(this),tokenId);

        emit idl̥MarketItemCreated(tokenId,msg.sender,address(this),price,false);
    }

    //Function for resale token

    function reSellToken(uint256 tokenId,uint256 price) public payable{
        require(idMarketItem[tokenId].owner == msg.sender,"Only item owner can do this operation");
        require(msg.value == listingPrice,"Price must be equal to listing price");

        idMarketItem[tokenId].sold=false;
        idMarketItem[tokenId].price=price;
        idMarketItem[tokenId].seller=payable(msg.sender);
         idMarketItem[tokenId].owner=payable(address(this));


         _itemSold.decrement();

         _transfer(msg.sender,address(this),tokenId);

    }

    //Function create market sale

    function createMarketSale(uint256 tokenId) public payable{
        uint256 price =idMarketItem[tokenId].price;

        require(msg.value==price,"please submit the asking price in order to complte the purchase");

        idMarketItem[tokenId].owner=payable(msg.sender);
        idMarketItem[tokenId].sold=true;
        idMarketItem[tokenId].owner = payable(address(0));

        _itemSold.increment();

        _transfer(address(this),msg.sender,tokenId);

        payable(owner).transfer(listingPrice);

        payable(idMarketItem[tokenId].seller).transfer(msg.value);
    }

    //GETTING UNSOLD NFT DATA

    function fetchMarketItem() public view returns (MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unSoldItemCount = _tokenIds.current();
        - _itemSold.current();
        uint256 currentIndex=0;


      sett mattt
     
    }
}

