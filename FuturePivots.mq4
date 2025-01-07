//+------------------------------------------------------------------+
//|                                                 FuturePivots.mq4 |
//|                                  Copyright 2022, FEARLESS SPIDER |
//|                                         https://www.daxtrader.pl |
//+------------------------------------------------------------------+
#property copyright "Copyright, Spider's LAB OU"
#property link      "https://www.alphatrader.pl"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 13

enum indicatorMode
  {
   bullishMode       = 0, // Bullish Mode
   bearishMode       = 1, // Bearish Mode
  };

enum timeFrames
  {
   Daily       = 1,
   Weekly      = 2,
   Monthly     = 3,
  };

input indicatorMode  modeInd = bullishMode; // Indicator Mode

extern int              CountPeriods=10;
extern timeFrames       TimePeriod=Daily;
extern color            ColorPP=clrGray;
extern color            ColorBuyZone=clrDarkSeaGreen;
extern color            ColorSellZone=clrMistyRose;

string   period;

datetime timestart,
         timeend;

double   open,
         close,
         high,
         low;

double   PP,         // Pivot Levels
         R1,
         R2,
         R3,
         S1,
         S2,
         S3,
         M0,
         M1,
         M2,
         M3,
         M4,
         M5,
         rangeopen1, // OHLC Levels
         rangeopen2,
         rangeclose1,
         rangeclose2;

int      shift;

string NotesFont = "Cambria";
int NotesLocation_x = 10;
int NotesLocation_y = 10;
int TaillePolice = 16;
color  NotesColor = White;


double  buffer_PP[];
double  buffer_R1[];
double  buffer_R2[];
double  buffer_R3[];
double  buffer_S1[];
double  buffer_S2[];
double  buffer_S3[];
double  buffer_M0[];
double  buffer_M1[];
double  buffer_M2[];
double  buffer_M3[];
double  buffer_M4[];
double  buffer_M5[];

//+------------------------------------------------------------------------------------+
//      Variables for Handling of Licensing Restrictions
//+------------------------------------------------------------------------------------+
bool
boolRestrictExpiration     = true, // Set to true, to use an Experation Date
boolRestrictAccountNumber  = false, // Set to true for Restricting by Account Number
boolRestrictAccountName    = false, // Set to true for Restricting by Account Name
boolRestrictAccountServer  = false, // Set to true for Restricting by Account Server
boolRestrictAccountCompany = false, // Set to true for Restricting by Account Company
boolRestrictDemoAccount    = false, // Set to true, to only allow Demo Accounts
boolRestrictSymbols        = false, // Set to true, to only allow certain Symbols
boolRestrictAlert          = true,  // Display Alert Message when Restrictions apply
boolRestrictionsUnverified = false, // DO NOT CHANGE. For internal use only!
boolRestrictions           = false; // DO NOT CHANGE. For internal use only!
datetime
dtRestrictExpiration       = D'2022.06.5';  // Restricted by Expration Date
long
longRestrictAccountNumber  = 2100085715;      // Restricted by Account Number
string
strRestrictAccountName     = "Client Name",  // Restricted by Account Name
strRestrictAccountServer   = "Server Name",  // Restricted by Account Server
strRestrictAccountCompany  = "Company Name", // Restricted by Account Company
strRestrictSymbols[]       = { "EURUSD", "GBPJPY", "NZDCAD" }, // Restricted Symbols
                             strRestrictAlertCaption    = "Restrictions", // Alert Message Box Caption
                             strRestrictAlertMessage    =
                                "ATTENTION! Due to Licensing Restrictions, code execution has been blocked!";
// Message to be used when Restrictions have been detected
//+------------------------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
// Check Licensing Restrictions
   if(boolRestrictOnInit())
      return(INIT_FAILED);

   SetIndexBuffer(0,buffer_PP);
   SetIndexBuffer(1,buffer_R1);
   SetIndexBuffer(2,buffer_R2);
   SetIndexBuffer(3,buffer_R3);
   SetIndexBuffer(4,buffer_S1);
   SetIndexBuffer(5,buffer_S2);
   SetIndexBuffer(6,buffer_S3);
   SetIndexBuffer(7,buffer_M0);
   SetIndexBuffer(8,buffer_M1);
   SetIndexBuffer(9,buffer_M2);
   SetIndexBuffer(10,buffer_M3);
   SetIndexBuffer(11,buffer_M4);
   SetIndexBuffer(12,buffer_M5);

   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_NONE);
   SetIndexStyle(5,DRAW_NONE);
   SetIndexStyle(6,DRAW_NONE);
   SetIndexStyle(7,DRAW_NONE);
   SetIndexStyle(8,DRAW_NONE);
   SetIndexStyle(9,DRAW_NONE);
   SetIndexStyle(10,DRAW_NONE);
   SetIndexStyle(11,DRAW_NONE);
   SetIndexStyle(12,DRAW_NONE);


   if(TimePeriod==Daily)
     {
      period="D1";
     }
   if(TimePeriod==Weekly)
     {
      period="W1";
     }
   if(TimePeriod==Monthly)
     {
      period="MN1";
     }

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
// Check Licensing Restrictions
   if(boolRestrictOnTick())
      return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   for(shift=0; shift<=CountPeriods; shift++)
     {
      LevelsDelete(period+shift);
     }
   LevelsDelete("F"+period);

   for(shift=CountPeriods-1; shift>=0; shift--)
     {
      timestart = iTime(NULL,timePeriodConverter(),shift);
      timeend   = iTime(NULL,timePeriodConverter(),shift)+timePeriodConverter()*60;

      LevelsDraw(shift+1,timestart,timeend,period+shift,false);
      ChartRedraw();
     }

   timestart=iTime(NULL,timePeriodConverter(),0)+timePeriodConverter()*60;
   timeend=iTime(NULL,timePeriodConverter(),0)+timePeriodConverter()*120;

   LevelsDraw(0,timestart,timeend,"F"+period,true);
   ChartRedraw();
   return(rates_total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(shift=0; shift<=CountPeriods; shift++)
     {
      LevelsDelete(period+shift);
     }
   LevelsDelete("F"+period);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void draw_obj(string obj,string text,int size,color clr,int cor,int x,int y,string font)
  {
   ObjectDelete(obj);
   ObjectCreate(obj,OBJ_LABEL,0,0,0);
   ObjectSetText(obj,text,size,font,clr);
   ObjectSet(obj,OBJPROP_CORNER,cor);
   ObjectSet(obj,OBJPROP_XDISTANCE,x);
   ObjectSet(obj,OBJPROP_YDISTANCE,y);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LevelsDelete(string name)
  {
   if(ObjectFind("R3"+name) >= 0)
      ObjectDelete("R3"+name);
   if(ObjectFind("R2"+name) >= 0)
      ObjectDelete("R2"+name);
   if(ObjectFind("R1"+name) >= 0)
      ObjectDelete("R1"+name);
   if(ObjectFind("PP"+name) >= 0)
      ObjectDelete("PP"+name);
   if(ObjectFind("S1"+name) >= 0)
      ObjectDelete("S1"+name);
   if(ObjectFind("S2"+name) >= 0)
      ObjectDelete("S2"+name);
   if(ObjectFind("S3"+name) >= 0)
      ObjectDelete("S3"+name);


   if(ObjectFind("R3P"+name) >= 0)
      ObjectDelete("R3P"+name);
   if(ObjectFind("R2P"+name) >= 0)
      ObjectDelete("R2P"+name);
   if(ObjectFind("R1P"+name) >= 0)
      ObjectDelete("R1P"+name);
   if(ObjectFind("PPP"+name) >= 0)
      ObjectDelete("PPP"+name);
   if(ObjectFind("S1P"+name) >= 0)
      ObjectDelete("S1P"+name);
   if(ObjectFind("S2P"+name) >= 0)
      ObjectDelete("S2P"+name);
   if(ObjectFind("S3P"+name) >= 0)
      ObjectDelete("S3P"+name);


   if(ObjectFind("R3L"+name) >= 0)
      ObjectDelete("R3L"+name);
   if(ObjectFind("R2L"+name) >= 0)
      ObjectDelete("R2L"+name);
   if(ObjectFind("R1L"+name) >= 0)
      ObjectDelete("R1L"+name);
   if(ObjectFind("PPL"+name) >= 0)
      ObjectDelete("PPL"+name);
   if(ObjectFind("S1L"+name) >= 0)
      ObjectDelete("S1L"+name);
   if(ObjectFind("S2L"+name) >= 0)
      ObjectDelete("S2L"+name);
   if(ObjectFind("S3L"+name) >= 0)
      ObjectDelete("S3L"+name);


   if(ObjectFind("M0"+name) >= 0)
      ObjectDelete("M0"+name);
   if(ObjectFind("M1"+name) >= 0)
      ObjectDelete("M1"+name);
   if(ObjectFind("M2"+name) >= 0)
      ObjectDelete("M2"+name);
   if(ObjectFind("M3"+name) >= 0)
      ObjectDelete("M3"+name);
   if(ObjectFind("M4"+name) >= 0)
      ObjectDelete("M4"+name);
   if(ObjectFind("M5"+name) >= 0)
      ObjectDelete("M5"+name);


   if(ObjectFind("M0P"+name) >= 0)
      ObjectDelete("M0P"+name);
   if(ObjectFind("M1P"+name) >= 0)
      ObjectDelete("M1P"+name);
   if(ObjectFind("M2P"+name) >= 0)
      ObjectDelete("M2P"+name);
   if(ObjectFind("M3P"+name) >= 0)
      ObjectDelete("M3P"+name);
   if(ObjectFind("M4P"+name) >= 0)
      ObjectDelete("M4P"+name);
   if(ObjectFind("M5P"+name) >= 0)
      ObjectDelete("M5P"+name);


   if(ObjectFind("M0L"+name) >= 0)
      ObjectDelete("M0L"+name);
   if(ObjectFind("M1L"+name) >= 0)
      ObjectDelete("M1L"+name);
   if(ObjectFind("M2L"+name) >= 0)
      ObjectDelete("M2L"+name);
   if(ObjectFind("M3L"+name) >= 0)
      ObjectDelete("M3L"+name);
   if(ObjectFind("M4L"+name) >= 0)
      ObjectDelete("M4L"+name);
   if(ObjectFind("M5L"+name) >= 0)
      ObjectDelete("M5L"+name);

   if(ObjectFind("BZ"+name) >= 0)
      ObjectDelete("BZ"+name);
   if(ObjectFind("SZ"+name) >= 0)
      ObjectDelete("SZ"+name);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PlotTrend(const long              chart_ID=0,
               string                  name="trendline",
               const int               subwindow=0,
               datetime                time1=0,
               double                  price1=0,
               datetime                time2=0,
               double                  price2=0,
               const color             clr=clrBlack,
               const ENUM_LINE_STYLE   style=STYLE_SOLID,
               const int               width=2,
               const bool              back=true,
               const bool              selection=false,
               const bool              ray=false,
               const bool              hidden=true)
  {
   ResetLastError();
   ObjectDelete(name);
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,subwindow,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,": failed to create arrow = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY,ray);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PlotRectangle(const long        chart_ID=0,
                   string            name="rectangle",
                   const int         subwindow=0,
                   datetime          time1=0,
                   double            price1=1,
                   datetime          time2=0,
                   double            price2=0,
                   const color       clr=clrGray,
                   const bool        back=true,
                   const bool        selection=false,
                   const bool        hidden=true)
  {
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,subwindow,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,": failed to create arrow = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PlotText(const long        chart_ID=0,
              string            name="text",
              const int         subwindow=0,
              datetime          time1=0,
              double            price1=0,
              const string      text="text",
              const string      font="Arial",
              const int         font_size=12,
              const color       clr=clrGray,
              const ENUM_ANCHOR_POINT anchor = ANCHOR_RIGHT_UPPER,
              const bool        back=true,
              const bool        selection=false,
              const bool        hidden=true)
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,subwindow,time1,price1))
     {
      Print(__FUNCTION__,": failed to create arrow = ",GetLastError());
      return(false);
     }
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LevelsDraw(int      shft,
                datetime tmestrt,
                datetime tmend,
                string   name,
                bool     future)
  {
   high  = iHigh(NULL,timePeriodConverter(),shft);
   low   = iLow(NULL,timePeriodConverter(),shft);
   open  = iOpen(NULL,timePeriodConverter(),shft);
   if(future==false)
     {
      close = iClose(NULL,timePeriodConverter(),shft);
     }
   else
     {
      close = Bid;
     }

   PP  = (high+low+close)/3.0;

   R1 = 2*PP-low;
   R2 = PP+(high - low);
   R3 = 0;

   S1 = 2*PP-high;
   S2 = PP-(high - low);
   S3 = 0;

   M0=0;
   M1=0.5*(S1+S2);
   M2=0.5*(PP+S1);
   M3=0.5*(PP+R1);
   M4=0.5*(R1+R2);
   M5=0;

   buffer_PP[shft] = PP;
   buffer_R1[shft] = R1;
   buffer_R2[shft] = R2;
   buffer_R3[shft] = R3;
   buffer_S1[shft] = S1;
   buffer_S2[shft] = S2;
   buffer_S3[shft] = S3;
   buffer_M0[shft] = M0;
   buffer_M1[shft] = M1;
   buffer_M2[shft] = M2;
   buffer_M3[shft] = M3;
   buffer_M4[shft] = M4;
   buffer_M5[shft] = M5;

   rangeopen1  = (open-low)/((high-low)/100);
   rangeopen2  = 100-((open-low)/((high-low)/100));
   rangeclose1 = (close-low)/((high-low)/100);
   rangeclose2 = 100-((close-low)/((high-low)/100));

   if(modeInd == bullishMode)
     {
      PlotTrend(ChartID(),"R2"+name,0,tmestrt,R2,tmend,R2,ColorPP,STYLE_SOLID,3);
      PlotRectangle(ChartID(),"BZ"+name,0,tmestrt,PP,tmend,M2,ColorBuyZone);
      if(future == true)
        {
         draw_obj("CP","Copyright "+IntegerToString(TimeYear(TimeCurrent()))+", Spider's LAB OU for AlphaTRADER",TaillePolice,ColorPP,4,NotesLocation_x+400,NotesLocation_y,NotesFont);
         draw_obj("tradingZone","Next Projected Buy Zone : "+DoubleToStr(PP,Digits)+" - "+DoubleToStr(M2,Digits),TaillePolice,ColorBuyZone,4,NotesLocation_x+400,NotesLocation_y+20,NotesFont);
        }
      PlotText(ChartID(),"R2L"+name,0,tmend,R2,"Bullish Profit Zone","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotTrend(ChartID(),"M4"+name,0,tmestrt,M4,tmend,M4,ColorPP,STYLE_DASH,1);
      PlotTrend(ChartID(),"M5"+name,0,tmestrt,M5,tmend,M5,ColorPP,STYLE_DASH,1);
      PlotText(ChartID(),"M2L"+name,0,tmend,M2,"Bullish Buying Zone","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotText(ChartID(),"M5L"+name,0,tmend,M5,"M5","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotText(ChartID(),"M4P"+name,0,tmestrt,M4,DoubleToString(M4,4),"Arial",10,ColorPP,ANCHOR_LEFT_UPPER);
      PlotText(ChartID(),"M5P"+name,0,tmestrt,M5,DoubleToString(M5,4),"Arial",10,ColorPP,ANCHOR_LEFT_UPPER);
     }

   PlotTrend(0,"PP"+name,0,tmestrt,PP,tmend,PP,ColorPP,STYLE_SOLID,3);

   if(modeInd == bearishMode)
     {
      PlotTrend(ChartID(),"S2"+name,0,tmestrt,S2,tmend,S2,ColorPP,STYLE_SOLID,3);
      PlotText(ChartID(),"S2L"+name,0,tmend,S2,"Bearish Profit Zone","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotTrend(ChartID(),"M0"+name,0,tmestrt,M0,tmend,M0,ColorPP,STYLE_DASH,1);
      PlotTrend(ChartID(),"M1"+name,0,tmestrt,M1,tmend,M1,ColorPP,STYLE_DASH,1);
      PlotText(ChartID(),"M0L"+name,0,tmend,M0,"M0","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotText(ChartID(),"M3L"+name,0,tmend,M3,"Bearish Selling Zone","Arial",10,ColorPP,ANCHOR_RIGHT_UPPER);
      PlotText(ChartID(),"M0P"+name,0,tmestrt,M0,DoubleToString(M0,4),"Arial",10,ColorPP,ANCHOR_LEFT_UPPER);
      PlotText(ChartID(),"M1P"+name,0,tmestrt,M1,DoubleToString(M1,4),"Arial",10,ColorPP,ANCHOR_LEFT_UPPER);
      PlotRectangle(ChartID(),"SZ"+name,0,tmestrt,PP,tmend,M3,ColorSellZone);
      if(future == true)
        {
         draw_obj("CP","Copyright "+IntegerToString(TimeYear(TimeCurrent()))+", Spider's LAB OU for AlphaTRADER",TaillePolice,ColorPP,4,NotesLocation_x+400,NotesLocation_y,NotesFont);
         draw_obj("tradingZone","Next Projected Sell Zone : "+DoubleToStr(PP,Digits)+" - "+DoubleToStr(M3,Digits),TaillePolice,ColorSellZone,4,NotesLocation_x+400,NotesLocation_y+20,NotesFont);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES timePeriodConverter()
  {
   ENUM_TIMEFRAMES tmf = 0;
   if(TimePeriod == Daily)
      tmf = PERIOD_D1;
   if(TimePeriod == Weekly)
      tmf = PERIOD_W1;
   if(TimePeriod == Monthly)
      tmf = PERIOD_MN1;
   return(tmf);
  }

//+------------------------------------------------------------------------------------+
// Function to Test Restrictions during Initialisation
//+------------------------------------------------------------------------------------+
bool boolRestrictOnInit()
  {
   boolRestrictions =
      boolRestrictExpiration     ||
      boolRestrictAccountNumber  ||
      boolRestrictAccountName    ||
      boolRestrictAccountServer  ||
      boolRestrictAccountCompany ||
      boolRestrictDemoAccount    ||
      boolRestrictSymbols;

   if(boolRestrictions)
     {
      boolRestrictionsUnverified = true;

      if((bool) TerminalInfoInteger(TERMINAL_CONNECTED))
        {
         long longAccountNumber = AccountInfoInteger(ACCOUNT_LOGIN);
         if(longAccountNumber > 0)
           {
            if(boolRestrictAccountNumber)
              {
               if(longAccountNumber                        != longRestrictAccountNumber)
                 { return(boolRestrictAlert()); }
              }
            if(boolRestrictAccountName)
              {
               if(AccountInfoString(ACCOUNT_NAME)        != strRestrictAccountName)
                 { return(boolRestrictAlert()); }
              }
            if(boolRestrictAccountServer)
              {
               if(AccountInfoString(ACCOUNT_SERVER)      != strRestrictAccountServer)
                 { return(boolRestrictAlert()); }
              }
            if(boolRestrictAccountCompany)
              {
               if(AccountInfoString(ACCOUNT_COMPANY)     != strRestrictAccountCompany)
                 { return(boolRestrictAlert()); }
              }
            if(boolRestrictDemoAccount)
              {
               if(AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_DEMO)
                 { return(boolRestrictAlert()); }
              }
            if(boolRestrictSymbols())
              { return(boolRestrictAlert()); }

            boolRestrictionsUnverified = false;
           }
        }
     }
   return(false);
  }

//+------------------------------------------------------------------------------------+
// Function to Test Variations of Restricted Symbols
//+------------------------------------------------------------------------------------+
bool boolRestrictSymbols()
  {
   if(boolRestrictSymbols)
     {
      int intSymbolCount = ArraySize(strRestrictSymbols);
      if(intSymbolCount == 0)
         return(false);
      for(int i = 0; i < intSymbolCount; i++)
        {
         if(StringFind(_Symbol, strRestrictSymbols[i]) != WRONG_VALUE)
            return(false);
         int
         intLen  = StringLen(strRestrictSymbols[i]),
         intHalf = intLen / 2;
         string
         strLeft  = StringSubstr(strRestrictSymbols[i], 0, intHalf),
         strRight = StringSubstr(strRestrictSymbols[i], intHalf, intLen - intHalf);
         if((StringFind(_Symbol, strLeft) != WRONG_VALUE) &&
            (StringFind(_Symbol, strRight) != WRONG_VALUE))
            return(false);
        }
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------------------------+
// Function to Test Expiration during Tick Events
//+------------------------------------------------------------------------------------+
bool boolRestrictOnTick()
  {
   if(boolRestrictions)
     {
      if(boolRestrictionsUnverified)
         return(boolRestrictOnInit());
      if(boolRestrictExpiration && (TimeCurrent() >= dtRestrictExpiration))
         return(boolRestrictAlert());
     }
   return(false);
  }
// Function to Alert User of Licensing Restrictions and Remove Code from Execution
bool boolRestrictAlert()
  {
   if(boolRestrictAlert)
     {
      Alert(strRestrictAlertMessage);
     }
   ExpertRemove();
   return(true);
  }
//+------------------------------------------------------------------+
