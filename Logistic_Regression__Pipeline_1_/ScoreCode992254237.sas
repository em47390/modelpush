   /*---------------------------------------------------------
     Generated SAS Scoring Code
     Date: 13Apr2023:07:32:50
     -------------------------------------------------------*/

   drop _badval_ _linp_ _temp_ _i_ _j_;
   _badval_ = 0;
   _linp_   = 0;
   _temp_   = 0;
   _i_      = 0;
   _j_      = 0;
   drop MACLOGBIG;
   MACLOGBIG= 7.0978271289338392e+02;

   array _xrow_95517271_0_{2} _temporary_;
   array _beta_95517271_0_{2} _temporary_ (    5.41689105770283
           -1.3959292806597);

   if missing(AVG_of_BLOWER02)
      then do;
         _badval_ = 1;
         goto skip_95517271_0;
   end;

   do _i_=1 to 2; _xrow_95517271_0_{_i_} = 0; end;

   _xrow_95517271_0_[1] = 1;

   _xrow_95517271_0_[2] = AVG_of_BLOWER02;

   do _i_=1 to 2;
      _linp_ + _xrow_95517271_0_{_i_} * _beta_95517271_0_{_i_};
   end;

   skip_95517271_0:
   length I_DEF $5;
   label I_DEF = 'Into: DEF';
   array _levels_95517271_{2} $ 5 _TEMPORARY_ ('OK'
   ,'MIS_H'
   );
   label P_DEFOK = 'Predicted: DEF=OK';
   if (_badval_ eq 0) and not missing(_linp_) then do;
      if (_linp_ > 0) then do;
         P_DEFOK = 1 / (1+exp(-_linp_));
      end; else do;
         P_DEFOK = exp(_linp_) / (1+exp(_linp_));
      end;
      P_DEFMIS_H = 1 - P_DEFOK;
      if P_DEFOK >= 0.5                  then do;
         I_DEF = _levels_95517271_{1};
      end; else do;
         I_DEF = _levels_95517271_{2};
      end;
   end; else do;
      _linp_ = .;
      P_DEFOK = .;
      P_DEFMIS_H = .;
      I_DEF = ' ';
   end;


   *------------------------------------------------------------*;
   * Initializing missing posterior and classification variables ;
   *------------------------------------------------------------*;
   label "P_DEFMIS_H"n ='Predicted: DEF=MIS_H';
   if "P_DEFMIS_H"n = . then "P_DEFMIS_H"n =0.0360576923;
   label "P_DEFOK"n ='Predicted: DEF=OK';
   if "P_DEFOK"n = . then "P_DEFOK"n =0.9639423077;
   label "I_DEF"n ='Into: DEF';
   if missing('I_DEF'n) then do;
      drop _P_;
      _P_= 0.0 ;
      if 'P_DEFOK'n > _P_ then do;
      _P_ = 'P_DEFOK'n;
      'I_DEF'n = 'OK';
      end;
      if 'P_DEFMIS_H'n > _P_ then do;
      _P_ = 'P_DEFMIS_H'n;
      'I_DEF'n = 'MIS_H';
      end;
   end;
