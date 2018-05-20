module huffman(clk, reset, gray_valid, gray_data, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output CNT_valid;
output [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output code_valid;
output [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output [7:0] M1, M2, M3, M4, M5, M6;

reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
reg CNT_valid;

reg code_valid;
reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
reg [7:0] M1, M2, M3, M4, M5, M6;

// FSM
parameter
IDLE       = 0, 
LOAD_NT    = 1,
LOAD_LIST  = 2,
SORTING    = 3,
BUILD_TREE = 4,
READ_TREE  = 5,
DONE       = 6;
reg [2:0] cs;
reg [2:0] ns;

// Controller


// Counter
reg rst_cnt;
reg en_cnt;
reg [6:0] cnt;

// Counter2
reg rst_cnt2;
reg en_cnt2;
reg [3:0] cnt2;

// List
reg [2:0] rda_List;
reg [3:0] rd_Lt;
reg [7:0] rd_Lv;

reg wen_List;
reg [2:0] wra_List;
reg [3:0] wr_Lt;
reg [7:0] wr_Lv;

parameter
SRC_RA     = 0,
SRC_RB     = 1,
SRC_AplusB = 2;
reg [1:0] src_wr_L;

reg [3:0] ListA [0:5];
reg [7:0] ListB [0:5];

// List Reg A & B and index
parameter
FROM_List = 0,
FROM_RB   = 1;

reg en_RegA;
reg src_RA;
reg [3:0] RegA_t;
reg [7:0] RegA_v;

reg en_RegB;
reg src_RB;
reg [3:0] RegB_t;
reg [7:0] RegB_v;

reg [2:0] L_idx;

// for loop i & j & k 
reg rst_i;
reg en_i;
reg [2:0] num_i;
reg [2:0] int_i;

reg rst_j;
reg en_j;
reg [2:0] num_j;
reg [2:0] int_j;

reg rst_k;
reg en_k;
reg [2:0] num_k;
reg [2:0] int_k;

// Compare A & B
reg cmpA_B;

// Tree
reg [2:0] rda_Tree;
reg [3:0] rd_T1;
reg [3:0] rd_T0;

reg wen_Tree;
reg [2:0] wra_Tree;
reg [3:0] wr_T1;
reg [3:0] wr_T0;

reg [3:0] Tree_1 [0:4];
reg [3:0] Tree_0 [0:4];

// node
reg en_node;
parameter
SRC_J    = 0,
SRC_Tree = 1;
reg src_node;
reg [3:0] node;

// tmp Tree
reg en_tmp_T;
reg [3:0] tmp_T1;
reg [3:0] tmp_T0;

// tmp Huffman code
reg rst_tmp_HC;
reg en_tmp_HC;
reg [7:0] tmp_HC;
reg [7:0] tmp_MK;
reg [7:0] addnum;

reg [2:0] wra_tmp_HC;
reg wen_tmp_HC;

// compare T1 T0
reg isT1, isT0;
reg find;

// FSM
always@(*) begin
  ns = cs;
  case(cs)
  IDLE      : begin
    if(gray_valid)
      ns = LOAD_NT;
  end
  LOAD_NT   : begin
    if(!gray_valid)
      ns = LOAD_LIST;
  end
  LOAD_LIST : begin
    if(cnt==5) begin
      ns = SORTING;
    end
  end
  SORTING   : begin
    if(int_j==1 && cnt==4) begin
      ns = BUILD_TREE;
    end
  end
  BUILD_TREE: begin
    if(cnt==3) begin
      ns = SORTING;
      if(int_k==1) begin
        ns = READ_TREE;
      end
    end
  end
  READ_TREE : begin
    if(cnt[1:0]==3 && int_i==4 && int_j==1)
      ns = DONE;
  end
  DONE      : begin
  end
  endcase
end

// Controller
always@(*) begin
  code_valid = 0;
  
  // Counter
  rst_cnt = 0;
  en_cnt  = 0;
  
  // Counter2
  rst_cnt2 = 0;
  en_cnt2  = 0;

  // List
  rda_List = 0;
  wen_List = 0;
  wra_List = 0;

  // List Reg A & B
  en_RegA = 0;
  src_RA = FROM_List;
  en_RegB = 0;
  src_RB = FROM_List;
  
  src_wr_L = SRC_RA;

  // for loop i & j & k
  rst_i = 0;
  en_i  = 0;
  num_i = 0;

  rst_j = 0;
  en_j  = 0;
  num_j = 0;

  rst_k = 0;
  en_k  = 0;
  num_k = 0;

  // Tree
  rda_Tree = 0;
  wra_Tree = 0;
  wen_Tree = 0;

  // node
  en_node  = 0;
  src_node = SRC_J;
  
  // tmp Tree
  en_tmp_T = 0;

  // tmp Huffman code
  rst_tmp_HC = 0;
  en_tmp_HC  = 0;

  wra_tmp_HC = 0;
  wen_tmp_HC = 0;
  case(cs)
  IDLE      : begin
    rst_j = 1;
    num_j = 5;
    
    rst_k = 1;
    num_k = 5;
  end
  LOAD_NT   : begin
  end
  LOAD_LIST : begin
    en_cnt = 1;
    if(cnt==5) begin
      rst_cnt = 1;
    end
  end
  SORTING   : begin
    case(cnt[2:0]) // for j
    0:begin
      en_RegA = 1;
      
      rst_i = 1;
      num_i = 1;

      en_cnt = 1;
    end
    1:begin
      case(cnt2[1:0]) // for i
      0:begin
        rda_List = int_i;
        en_RegB = 1;        
	en_cnt2 = 1;
      end
      1:begin
	en_cnt2 = 1;
      end
      2:begin
        if(cmpA_B) begin
          en_RegA = 1;
	  src_RA  = FROM_RB;
	end	  
        rst_cnt2 = 1;
        en_i = 1;
	if(int_i==int_j) begin
          en_cnt = 1;
	end
      end
      endcase
    end
    2:begin
      rda_List = int_j;
      en_RegB = 1;        

      en_cnt = 1;
    end
    3:begin
      wen_List = 1;
      wra_List = int_j;
      src_wr_L = SRC_RA;

      en_cnt = 1;
    end
    4:begin
      wen_List = 1;
      wra_List = L_idx;
      src_wr_L = SRC_RB;

      en_j    = 1;
      rst_cnt = 1;
    end
    endcase
  end
  BUILD_TREE: begin
    en_cnt = 1;
    case(cnt[1:0])
    0:begin
      rda_List = int_k;
      en_RegA  = 1;              
    end
    1:begin
      rda_List = int_k-1;
      en_RegB  = 1;              
    end
    2:begin      
    end
    3:begin
      // Tree
      wra_Tree = 5-int_k;
      wen_Tree = 1;

      // List
      wen_List = 1;
      wra_List = int_k-1; 
      src_wr_L = SRC_AplusB;
      
      rst_j = 1;
      num_j = int_k-1;

      en_k    = 1;
      rst_cnt = 1;
      if(int_k==1) begin
        rst_i = 1;
	num_i = 0;

        num_j = 6;

	rst_tmp_HC = 1;
      end
    end
    endcase
  end
  READ_TREE : begin
    en_cnt = 1;
    case(cnt[1:0])
    0:begin
      rda_Tree = int_i;
      en_tmp_T = 1;

      if(int_i==0) begin
        en_node = 1;
      end
    end
    1:begin 
    end
    2:begin 
      if(find) begin
        // Tree
        en_node  = 1;
	src_node = SRC_Tree;

	// Huffman code
	en_tmp_HC = 1;
      end
    end
    3:begin    
      en_i = 1;
      if(int_i==4) begin
        // Huffman code
	rst_tmp_HC = 1;
	wra_tmp_HC = int_j;
	wen_tmp_HC = 1;

        rst_i = 1;
        num_i = 0;

        en_j = 1;
      end
      rst_cnt = 1;
    end
    endcase
  end
  DONE      : begin
    code_valid = 1;
  end
  endcase
end

// CNT
always@(posedge clk or posedge reset) begin
  if(reset) begin
    CNT1 <= 0; 
    CNT2 <= 0; 
    CNT3 <= 0;  
    CNT4 <= 0; 
    CNT5 <= 0; 
    CNT6 <= 0; 
  end
  else begin
    if(gray_valid) begin
      case(gray_data)
      1:CNT1 <= CNT1 + 1; 
      2:CNT2 <= CNT2 + 1;
      3:CNT3 <= CNT3 + 1;
      4:CNT4 <= CNT4 + 1;
      5:CNT5 <= CNT5 + 1;
      6:CNT6 <= CNT6 + 1;
      endcase
    end
  end
end

// Counter
always@(posedge clk or posedge reset) begin
  if(reset) begin
    cnt <= 0;
  end
  else begin
    if(rst_cnt)      cnt <= 0; 
    else if (en_cnt) cnt <= cnt + 1;
  end
end

// Counter2
always@(posedge clk or posedge reset) begin
  if(reset) begin
    cnt2 <= 0;
  end
  else begin
    if(rst_cnt2)      cnt2 <= 0; 
    else if (en_cnt2) cnt2 <= cnt2 + 1;
  end
end

// List
  // Read
always@(*) begin
  rd_Lt = ListA[rda_List];
  rd_Lv = ListB[rda_List];
end

  // Select write date
always@(*) begin
  wr_Lt = RegA_t;
  wr_Lv = RegA_v;
  case(src_wr_L)
  SRC_RA: begin
    wr_Lt = RegA_t;
    wr_Lv = RegA_v;
  end
  SRC_RB: begin
    wr_Lt = RegB_t;
    wr_Lv = RegB_v;
  end
  SRC_AplusB: begin
    wr_Lt = 12-int_k;
    wr_Lv = RegA_v+RegB_v;
  end
  endcase
end

  // Write
always@(posedge clk) begin
  if(cs==LOAD_LIST) begin
    case(cnt[2:0])
    0:ListA[0] <= 1; 
    1:ListA[1] <= 2;
    2:ListA[2] <= 3;
    3:ListA[3] <= 4;
    4:ListA[4] <= 5;
    5:ListA[5] <= 6;
    endcase

    case(cnt[2:0])
    0:ListB[0] <= CNT1; 
    1:ListB[1] <= CNT2;
    2:ListB[2] <= CNT3;
    3:ListB[3] <= CNT4;
    4:ListB[4] <= CNT5;
    5:ListB[5] <= CNT6;
    endcase
  end
  else if(wen_List) begin
    ListA[wra_List] <= wr_Lt; 
    ListB[wra_List] <= wr_Lv; 
  end
end

// List Reg A & B and index
always@(posedge clk) begin
  // Reg A
  if(en_RegA) begin
    case(src_RA)
    FROM_List: begin
      L_idx  <= 0;
      RegA_t <= rd_Lt;
      RegA_v <= rd_Lv;
    end
    FROM_RB  : begin
      L_idx  <= int_i;
      RegA_t <= RegB_t;
      RegA_v <= RegB_v;
    end
    endcase
  end

  // Reg B
  if(en_RegB) begin
    case(src_RB)
    FROM_List: begin
      RegB_t <= rd_Lt;
      RegB_v <= rd_Lv;
    end
    endcase
  end
end

// for loop i & j & k 
always@(posedge clk or posedge reset) begin
  if(reset) begin
    int_i <= 0; 
    int_j <= 0; 
    int_k <= 0; 
  end
  else begin
    if(rst_i)     int_i <= num_i;
    else if(en_i) int_i <= int_i + 1;

    if(rst_j)     int_j <= num_j;
    else if(en_j) int_j <= int_j - 1;

    if(rst_k)     int_k <= num_k;
    else if(en_k) int_k <= int_k - 1;
  end
end

// Compare A & B
always@(*) begin
  cmpA_B = 0;
  if(RegA_v>RegB_v) 
    cmpA_B = 1;
  else if(RegA_v==RegB_v && RegA_t<RegB_t)
    cmpA_B = 1;
end

// Tree
  // Read
always@(*) begin
  rd_T1 = Tree_1[rda_Tree];
  rd_T0 = Tree_0[rda_Tree];
end

  // Select write date
always@(*) begin
  wr_T1 = RegA_t;
  wr_T0 = RegB_t;
  case(cmpA_B)
  0: begin // B > A
    wr_T1 = RegA_t;
    wr_T0 = RegB_t;
  end
  1: begin // A > B
    wr_T1 = RegB_t;
    wr_T0 = RegA_t;
  end
  endcase
end

  // Write
always@(posedge clk) begin
  if(wen_Tree) begin
    Tree_1[wra_Tree] <= wr_T1;
    Tree_0[wra_Tree] <= wr_T0;
  end
end

// node
always@(posedge clk) begin
  if(en_node) begin
    case(src_node)
    SRC_J:   node <= int_j;
    SRC_Tree:node <= int_i+7;
    endcase
  end
end

// tmp Tree
always@(posedge clk) begin
  if(en_tmp_T) begin
    tmp_T1 <= rd_T1;
    tmp_T0 <= rd_T0;
  end
end

// tmp Huffman code
  // make tmp code
always@(posedge clk) begin
  if(rst_tmp_HC) begin
    tmp_HC <= 0;
    tmp_MK <= 0;
    addnum <= 1;
  end
  else if(en_tmp_HC) begin
    if(isT1)
      tmp_HC <= tmp_HC + addnum;

    tmp_MK <= {tmp_MK[6:0], 1'b1};
    addnum <= {addnum[6:0], 1'b0};
  end
end

  // write to HC & M
always@(posedge clk) begin
  if(wen_tmp_HC) begin
    case(wra_tmp_HC)
    1:begin
      HC1 <= tmp_HC; 
      M1  <= tmp_MK;
    end
    2:begin  
      HC2 <= tmp_HC; 
      M2  <= tmp_MK;
    end
    3:begin  
      HC3 <= tmp_HC; 
      M3  <= tmp_MK;
    end
    4:begin  
      HC4 <= tmp_HC; 
      M4  <= tmp_MK;
    end
    5:begin  
      HC5 <= tmp_HC; 
      M5  <= tmp_MK;
    end
    6:begin  
      HC6 <= tmp_HC; 
      M6  <= tmp_MK;
    end
    endcase
  end
end

// compare T0 T1
always@(*) begin
  isT1 = (node==tmp_T1);
  isT0 = (node==tmp_T0);
  find = (isT1 || isT0);
end

always@(posedge clk or posedge reset) begin
  if(reset) begin
    cs <= IDLE;

    CNT_valid <= 0; 
  end
  else begin
    cs <= ns;

    CNT_valid <= (cs==LOAD_NT && !gray_valid); 
  end
end

endmodule












