//+------------------------------------------------------------------+
//|                                                  KhaiNuiZone.mq5 |
//|                              Copyright 2024, The Market Survivor |
//|                       https://www.facebook.com/TheMarketSurvivor |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, The Market Survivor"
#property link      "https://www.facebook.com/TheMarketSurvivor"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input double  LotSize  = 0.01;     // Lot size for the Buy order
input int     Slippage = 3;       // Slippage in points
input int     MagicNumber = 123456; // Magic number for identifying orders

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Check if there are no open positions
   if(PositionsTotal() == 0)
     {
      // Call the function to open a Buy order
      OpenBuyOrder();
     }
  }

//+------------------------------------------------------------------+
//| Function to open a Buy order                                     |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {
// Prepare the trade request and result structures
   MqlTradeRequest request; // Create the request structure
   MqlTradeResult result;   // Create the result structure

// Initialize the request structure with zero values
   ZeroMemory(request);
   ZeroMemory(result);

// Fill the trade request structure
   request.action       = TRADE_ACTION_DEAL;      // Place an order
   request.symbol       = _Symbol;                // Symbol to trade
   request.volume       = LotSize;                // Lot size
   request.type         = ORDER_TYPE_BUY;         // Buy order
   request.price        = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Current Bid price
   request.deviation    = Slippage;              // Maximum price slippage
   request.magic        = MagicNumber;            // Magic number from input
   request.comment      = "Buy order";            // Comment
   request.type_filling = ORDER_FILLING_IOC;      // Filling policy Immediate or Cancel

// Send the trade request
   if(OrderSend(request, result))
     {
      Print("Buy order placed successfully! Ticket: ", result.order);
     }
   else
     {
      // Handle the error
      int errorCode = GetLastError();
      Print("Error placing Buy order: ", errorCode);
     }
  }

//+------------------------------------------------------------------+
