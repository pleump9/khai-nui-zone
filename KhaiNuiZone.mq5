//+------------------------------------------------------------------+
//|                                                  KhaiNuiZone.mq5 |
//|                              Copyright 2024, The Market Survivor |
//|                       https://www.facebook.com/TheMarketSurvivor |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, The Market Survivor"
#property link      "https://www.facebook.com/TheMarketSurvivor"
#property version   "1.00"

#include <Trade\Trade.mqh>  // Include the CTrade class

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input double  LotSize  = 0.01;     // Lot size for the Buy order
input int     Slippage = 3;       // Slippage in points
input int     MagicNumber = 123456; // Magic number for identifying orders
input double  takeProfitMoney = 1;  // Take Profit amount in money

CTrade trade; // Create an instance of the CTrade class

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
   else
     {
      // Check profit of existing positions
      if(CheckPositionsProfit() <= takeProfitMoney)
        {
         // If profit is enough, close all positions
         CloseAllPositions();
        }
     }
  }

//+------------------------------------------------------------------+
//| Function to open a Buy order                                     |
//+------------------------------------------------------------------+
void OpenBuyOrder()
  {
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK); // Current Ask price

// Place a Buy order using the CTrade class
   if(trade.Buy(LotSize, _Symbol, 0, 0, 0, "Buy order"))
     {
      Print("Buy order placed successfully!");
     }
   else
     {
      // Handle the error
      int errorCode = GetLastError();
      Print("Error placing Buy order: ", errorCode);
     }
  }

//+------------------------------------------------------------------+
//| Function to check total profit of all positions                  |
//+------------------------------------------------------------------+
double CheckPositionsProfit()
  {
   double totalProfit = 0.0;

// Loop through all positions to calculate total profit
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         totalProfit += PositionGetDouble(POSITION_PROFIT);
        }
     }

   return totalProfit; // Return the total profit
  }

//+------------------------------------------------------------------+
//| Function to close all open positions                              |
//+------------------------------------------------------------------+
void CloseAllPositions()
  {
// Loop through all positions and close them
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         double volume = PositionGetDouble(POSITION_VOLUME); // Get volume to close
         double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID); // Current Bid price

         // Close the position using the CTrade class
         if(trade.PositionClose(ticket))
           {
            Print("Closed position successfully! Ticket: ", ticket);
           }
         else
           {
            // Handle the error
            int errorCode = GetLastError();
            Print("Error closing position: ", errorCode);
           }
        }
     }
  }

//+------------------------------------------------------------------+
