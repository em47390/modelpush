*------------------------------------------------------------*;
* Macro Variables for input, output data and files;
  %let dm_datalib       =;                 /* Libref associated with the CAS training table */
  %let dm_output_lib    = &dm_datalib;     /* Libref associated with the output CAS tables */
  %let dm_data_caslib   =;                 /* CASLIB associated with the training table */
  %let dm_output_caslib = &dm_data_caslib; /* CASLIB associated with the output tables */
  %let dm_inputTable=;  /* Input Table */
  %let dm_memName=_input_93GQLBVUVAYYGWZUXHWT8P1FX;
  %let dm_memNameNLit='_input_93GQLBVUVAYYGWZUXHWT8P1FX'n;
  %let dm_lib     = WORK;
  %let dm_folder  = %sysfunc(pathname(work));
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Training for logisticreg;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
  * Initializing Variable Macros;
*------------------------------------------------------------*;
%macro dm_assessforbias;
%mend dm_assessforbias;
%global dm_num_assessforbias;
%let dm_num_assessforbias = 0;
%macro dm_unary_input;
%mend dm_unary_input;
%global dm_num_unary_input;
%let dm_num_unary_input = 0;
%macro dm_interval_input;
'AVG_of_AMP01'n 'AVG_of_AMP1'n 'AVG_of_AMP10'n 'AVG_of_AMP11'n
'AVG_of_AMP12'n 'AVG_of_AMP13'n 'AVG_of_AMP14'n 'AVG_of_AMP15'n 'AVG_of_AMP16'n
'AVG_of_AMP2'n 'AVG_of_AMP3'n 'AVG_of_AMP4'n 'AVG_of_AMP5'n 'AVG_of_AMP6'n
'AVG_of_AMP7'n 'AVG_of_AMP8'n 'AVG_of_AMP9'n 'AVG_of_BLOWER01'n
'AVG_of_BLOWER02'n 'AVG_of_DEWPOINT01'n 'AVG_of_DPT01'n 'AVG_of_DPT02'n
'AVG_of_FEEDAMP'n 'AVG_of_FEEDHZ'n 'AVG_of_FLOW'n 'AVG_of_HZ01'n
'AVG_of_MILLAMP'n 'AVG_of_MILLHZ'n 'AVG_of_O2FT_MAIN'n 'AVG_of_PRESSURE01'n
'AVG_of_SEPAMP'n 'AVG_of_SEPHZ'n 'AVG_of_SPEED'n 'AVG_of_TEMP3'n
'AVG_of_TEMP4'n 'AVG_of_TEMP5'n 'AVG_of_TEMP6'n 'VALUE'n
%mend dm_interval_input;
%global dm_num_interval_input;
%let dm_num_interval_input = 38 ;
%macro dm_binary_input;
%mend dm_binary_input;
%global dm_num_binary_input;
%let dm_num_binary_input = 0;
%macro dm_nominal_input;
'INSP_ITEM'n 'LSL'n 'USL'n
%mend dm_nominal_input;
%global dm_num_nominal_input;
%let dm_num_nominal_input = 3 ;
%macro dm_ordinal_input;
%mend dm_ordinal_input;
%global dm_num_ordinal_input;
%let dm_num_ordinal_input = 0;
%macro dm_class_input;
'INSP_ITEM'n 'LSL'n 'USL'n
%mend dm_class_input;
%global dm_num_class_input;
%let dm_num_class_input = 3 ;
%macro dm_segment;
'_CLUSTER_ID_'n
%mend dm_segment;
%global dm_num_segment;
%let dm_num_segment = 1 ;
%macro dm_id;
%mend dm_id;
%global dm_num_id;
%let dm_num_id = 0;
%macro dm_text;
%mend dm_text;
%global dm_num_text;
%let dm_num_text = 0;
%macro dm_strat_vars;
'DEF'n '_CLUSTER_ID_'n
%mend dm_strat_vars;
%global dm_num_strat_vars;
%let dm_num_strat_vars = 2 ;
*------------------------------------------------------------*;
  * Initializing Macro Variables *;
*------------------------------------------------------------*;
  %let dm_data_outfit = &dm_lib..outfit;
  %let dm_file_scorecode = &dm_folder/scorecode.sas;
  %let dm_caslibOption =;
  data _null_;
     if index(symget('dm_data_caslib'), '(') or index(symget('dm_data_caslib'), ')' ) or (symget('dm_data_caslib')=' ') then do;
        call symput('dm_caslibOption', ' ');
     end;
     else do;
        call symput('dm_caslibOption', 'caslib="'!!ktrim(symget('dm_data_caslib'))!!'"');
     end;
  run;


*------------------------------------------------------------*;
  * Component Code;
*------------------------------------------------------------*;
proc genselect data=&dm_datalib..&dm_memnameNlit
     tech=NRRIDG normalize=YES
  ;
  partition rolevar='_PartInd_'n (TRAIN='1' VALIDATE='0' TEST='2');
  class
     %dm_class_input
     /
     param=GLM
     order=formatted
  ;
  model 'DEF'n
     (event='OK')=
     %dm_interval_input
     %dm_class_input
     / link=LOGIT dist=BINARY
  ;
  selection method=STEPWISE( choose=SBC stop=SBC slEntry=0.05 slStay=0.05 Hierarchy=NONE select=SBC );
  ods output 
     PredProbName = &dm_lib..PredProbName ModelInfo = &dm_lib..PredIntoName
     SelectionSummary = &dm_lib..Selection(drop=Control)
     ParameterEstimates   = &dm_lib..ParamEstsA
     FitStatistics        = &dm_lib..OutFit
  ;
  code file="&dm_file_scorecode."  pcatall iprob labelid=95517271;
run;
