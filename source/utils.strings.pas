(*
 *	 Unit owner: d10.天地弦
 *	       blog: http://www.cnblogs.com/dksoft
 *     homePage: www.diocp.org
 *
 *   2015-03-05 12:53:38
 *     修复URLEncode，URLDecode在Anddriod和UNICODE下的异常
 *
 *   2015-02-22 08:29:43
 *     DIOCP-V5 发布
 *
 *   2015-04-02 12:52:43
 *     修复SplitStrings,分隔符最后一个字符串没有加入的bug  abcd&33&eef
 *       感谢(Xjumping  990669769)反馈bug

 *  修正SearchPointer中的一严重bug(只比较了前两位字符的匹配性)
      2015-09-11 09:08:22
 *)
 
unit utils.strings;

interface

uses
  Classes, SysUtils
{$IFDEF MSWINDOWS}
    , windows
{$ELSE}
    , System.NetEncoding
{$ENDIF}
{$IF (RTLVersion>=26) and (not Defined(NEXTGEN))}
    , AnsiStrings
{$IFEND >=XE5}
  ;

type
{$IFDEF MSWINDOWS}  // Windows平台下面可以使用AnsiString
  URLString = AnsiString;
  URLChar = AnsiChar;
{$ELSE}
  // andriod下面使用
  URLString = String;
  URLChar = Char;
  {$DEFINE UNICODE_URL}
{$ENDIF}

{$IFDEF UNICODE}
  WChar = Char;
  PWChar = PChar;
{$ELSE}
  WChar = WideChar;
  PWChar = PWideChar;
{$ENDIF}

  // 25:XE5
  {$IF CompilerVersion<=25}
  IntPtr=Integer;
  {$IFEND}

  TArrayStrings = array of string;
  PArrayStrings = ^ TArrayStrings;



/// <summary>
///   跳过字符
/// </summary>
/// <returns>
///   返回跳过的字符
/// </returns>
/// <param name="p"> 开始检测位置 </param>
/// <param name="pvChars"> 遇到这些字符后停止，然后返回 </param>
function SkipUntil(var p:PChar; pvChars: TSysCharSet): Integer;




/// <summary>
///   跳过字符
/// </summary>
/// <returns>
///   返回跳过的字符个数
/// </returns>
/// <param name="p"> 源(字符串)位置 </param>
/// <param name="pvChars"> (TSysCharSet) </param>
function SkipChars(var p:PChar; pvChars: TSysCharSet): Integer;

/// <summary>
///   跳过字符串
///   // p = pchar("abcabcefggg");
///   // 执行后 p = "efgg"
///   // 返回结果 = 2 //2个abc
///   SkipStr(p, "abc");
///
/// </summary>
/// <returns>
///   返回跳过的字符串个数
/// </returns>
/// <param name="P"> 源字符，如果符合条件跳过 </param>
/// <param name="pvSkipStr"> 开头需要跳过的字符 </param>
/// <param name="pvIgnoreCase"> 忽略大小写 </param>
function SkipStr(var P:PChar; pvSkipStr: PChar; pvIgnoreCase: Boolean = true):
    Integer;


/// <summary>
///   检测是否以pvStart开头
/// </summary>
/// <returns> 如果为真返回true
/// </returns>
/// <param name="P"> (PChar) </param>
/// <param name="pvStart"> (PChar) </param>
/// <param name="pvIgnoreCase"> (Boolean) </param>
function StartWith(P:PChar; pvStart:PChar; pvIgnoreCase: Boolean = true):
    Boolean;


/// <summary>
///   从左边开始截取字符
/// </summary>
/// <returns>
///   返回截取到的字符串
/// </returns>
/// <param name="p"> 源(字符串)开始的位置, 匹配成功会出现在pvSpliter的首次出现位置, 否则不会进行移动</param>
/// <param name="pvChars"> (TSysCharSet) </param>
function LeftUntil(var p:PChar; pvChars: TSysCharSet): string;


/// <summary>
///   从左边开始截取字符串
/// </summary>
/// <returns>
///   返回截取到的字符串
/// </returns>
/// <param name="p"> 源(字符串), 匹配成功会出现在pvSpliter的首次出现位置, 否则不会进行移动 </param>
/// <param name="pvSpliter"> 分割(字符串) </param>
function LeftUntilStr(var P: PChar; pvSpliter: PChar; pvIgnoreCase: Boolean =
    true): string;

/// <summary>
///   根据SpliterChars中提供的字符，进行分割字符串，放入到Strings中
///     * 跳过字符前面的空格
/// </summary>
/// <returns>
///   返回分割的个数
/// </returns>
/// <param name="s"> 源字符串 </param>
/// <param name="pvStrings"> 输出到的字符串列表 </param>
/// <param name="pvSpliterChars"> 分隔符 </param>
function SplitStrings(s:String; pvStrings:TStrings; pvSpliterChars
    :TSysCharSet): Integer;


/// <summary>
///  将一个字符串分割成2个字符串
///  splitStr("key=abcd", "=", s1, s2)
///  // s1=key, s2=abcd
/// </summary>
/// <returns> 成功返回true
/// </returns>
/// <param name="s"> 要分割的字符串 </param>
/// <param name="pvSpliterStr"> (string) </param>
/// <param name="s1"> (String) </param>
/// <param name="s2"> (String) </param>
function SplitStr(s:string; pvSpliterStr:string; var s1, s2:String): Boolean;

/// <summary>
///   URL数据解码,
///    Get和Post的数据都经过了url编码
/// </summary>
/// <returns>
///   返回解码后的URL数据
/// </returns>
/// <param name="ASrc"> 原始数据 </param>
/// <param name="pvIsPostData"> Post的原始数据中原始的空格经过UrlEncode后变成+号 </param>
function URLDecode(const ASrc: URLString; pvIsPostData: Boolean = true):URLString;

/// <summary>
///  将数据进行URL编码
/// </summary>
/// <returns>
///   返回URL编码好的数据
/// </returns>
/// <param name="S"> 需要编码的数据 </param>
/// <param name="pvIsPostData"> Post的原始数据中原始的空格经过UrlEncode后变成+号 </param>
function URLEncode(S: URLString; pvIsPostData: Boolean = true): URLString;


/// <summary>
///  在Strings中根据名称搜索值
/// </summary>
/// <returns> String
/// </returns>
/// <param name="pvStrings"> (TStrings) </param>
/// <param name="pvName"> (string) </param>
/// <param name="pvSpliters"> 名字和值的分割符 </param>
function StringsValueOfName(pvStrings: TStrings; const pvName: string;
    pvSpliters: TSysCharSet; pvTrim: Boolean): String;


/// <summary>
///   查找PSub在P中出现的第一个位置
///   精确查找
///   如果PSub为空字符串(#0, nil)则直接返回P
/// </summary>
/// <returns>
///   如果找到, 返回第一个字符串位置
///   找不到返回False
///   * 来自qdac.qstrings
/// </returns>
/// <param name="P"> 要开始查找(字符串) </param>
/// <param name="PSub"> 要搜(字符串) </param>
function StrStr(P:PChar; PSub:PChar): PChar;

/// <summary>
///   查找PSub在P中出现的第一个位置
///   忽略大小写
///   如果PSub为空字符串(#0, nil)则直接返回P
/// </summary>
/// <returns>
///   如果找到, 返回第一个字符串位置
///   找不到返回nil
///   * 来自qdac.qstrings
/// </returns>
/// <param name="P"> 要开始查找(字符串) </param>
/// <param name="PSub"> 要搜(字符串) </param>
function StrStrIgnoreCase(P, PSub: PChar): PChar;


/// <summary>
///  字符转大写
///  * 来自qdac.qstrings
/// </summary>
function UpperChar(c: Char): Char;

/// <summary>
///  aStr是否在Strs列表中
/// </summary>
/// <returns>
///   如果在列表中返回true
/// </returns>
/// <param name="pvStr"> sensors,1,3.1415926,1.1,1.2,1.3 </param>
/// <param name="pvStringList"> (array of string) </param>
function StrIndexOf(const pvStr: string; const pvStringList: array of string):
    Integer;

/// <summary>
///   查找PSub在P中出现的第一个位置
/// </summary>
/// <returns>
///   如果找到, 返回指向第一个pvSub的位置
///   找不到返回 Nil
/// </returns>
/// <param name="pvSource"> 数据 </param>
/// <param name="pvSourceLen"> 数据长度 </param>
/// <param name="pvSub"> 查找的数据 </param>
/// <param name="pvSubLen"> 查找的数据长度 </param>
function SearchPointer(pvSource: Pointer; pvSourceLen, pvStartIndex: Integer;
    pvSub: Pointer; pvSubLen: Integer): Pointer;


/// <summary>procedure DeleteChars
/// </summary>
/// <returns> string
/// </returns>
/// <param name="s"> (string) </param>
/// <param name="pvCharSets"> (TSysCharSet) </param>
function DeleteChars(const s: string; pvCharSets: TSysCharSet): string;

/// <summary>
///  转换字符串到Bytes
/// </summary>
function StringToUtf8Bytes(pvData:String; pvBytes:TBytes): Integer;overload;

/// <summary>
///
/// </summary>
function Utf8BytesToString(pvBytes: TBytes; pvOffset: Cardinal): String;

function StringToUtf8Bytes(pvData:string): TBytes; overload;


implementation



{$IFDEF MSWINDOWS}
type
  TMSVCStrStr = function(s1, s2: PAnsiChar): PAnsiChar; cdecl;
  TMSVCStrStrW = function(s1, s2: PWChar): PWChar; cdecl;
  TMSVCMemCmp = function(s1, s2: Pointer; len: Integer): Integer; cdecl;

var
  hMsvcrtl: HMODULE;
  VCStrStr: TMSVCStrStr;
  VCStrStrW: TMSVCStrStrW;
  VCMemCmp: TMSVCMemCmp;
{$ENDIF}

{$if CompilerVersion < 20}
function CharInSet(C: Char; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;
{$ifend}


function DeleteChars(const s: string; pvCharSets: TSysCharSet): string;
var
  i, l, times: Integer;
  lvStr: string;
begin
  l := Length(s);
  SetLength(lvStr, l);
  times := 0;
  for i := 1 to l do
  begin
    if not CharInSet(s[i], pvCharSets) then
    begin
      inc(times);
      lvStr[times] := s[i];
    end;
  end;
  SetLength(lvStr, times);
  Result := lvStr;
end;


function StrIndexOf(const pvStr: string; const pvStringList: array of string):
    Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := Low(pvStringList) to High(pvStringList) do
  begin
    if SameText(pvStringList[i], pvStr) then
    begin
      Result := i;
      Break;
    end;
  end;
end;


function UpperChar(c: Char): Char;
begin
  {$IFDEF UNICODE}
  if (c >= #$61) and (c <= #$7A) then
    Result := Char(PWord(@c)^ xor $20)
  else
    Result := c;
  {$ELSE}
  if (c >= #$61) and (c <= #$7A) then
    Result := Char(ord(c) xor $20)
  else
    Result := c;
  {$ENDIF}
end;


function SkipUntil(var p:PChar; pvChars: TSysCharSet): Integer;
var
  ps: PChar;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if CharInSet(p^, pvChars) then
      Break
    else
      Inc(P);
  end;
  Result := p - ps;
end;

function LeftUntil(var p:PChar; pvChars: TSysCharSet): string;
var
  lvPTemp: PChar;
  l:Integer;
  lvMatched: Byte;
begin
  lvMatched := 0;
  lvPTemp := p;
  while lvPTemp^ <> #0 do
  begin
    if CharInSet(lvPTemp^, pvChars) then
    begin            // 匹配到
      lvMatched := 1;
      Break;
    end else
      Inc(lvPTemp);
  end;
  if lvMatched = 0 then
  begin   // 没有匹配到
    Result := '';
  end else
  begin   // 匹配到
    l := lvPTemp-P;
    SetLength(Result, l);
    if SizeOf(Char) = 1 then
    begin
      Move(P^, PChar(Result)^, l);
    end else
    begin
      l := l shl 1;
      Move(P^, PChar(Result)^, l);
    end;
    P := lvPTemp;  // 跳转到新位置
  end;
end;

function SkipChars(var p:PChar; pvChars: TSysCharSet): Integer;
var
  ps: PChar;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if CharInSet(p^, pvChars) then
      Inc(P)
    else
      Break;
  end;
  Result := p - ps;
end;


function SplitStrings(s:String; pvStrings:TStrings; pvSpliterChars
    :TSysCharSet): Integer;
var
  p:PChar;
  lvValue : String;
begin
  p := PChar(s);
  Result := 0;
  while True do
  begin
    // 跳过空白
    SkipChars(p, [' ']);
    lvValue := LeftUntil(P, pvSpliterChars);

    if lvValue = '' then
    begin
      if P^ <> #0 then
      begin  // 最后一个字符
        // 添加到列表中
        pvStrings.Add(P);
        inc(Result);
      end;
      Exit;
    end else
    begin
      // 跳过分隔符
      SkipChars(p, pvSpliterChars);

      // 添加到列表中
      pvStrings.Add(lvValue);
      inc(Result);
    end;
  end;
end;


function URLDecode(const ASrc: URLString; pvIsPostData: Boolean = true): URLString;
var
  i, j: integer;
  {$IFDEF UNICODE_URL}
  lvRawBytes:TBytes;
  lvSrcBytes:TBytes;
  {$ENDIF}
begin

  {$IFDEF UNICODE_URL}
  SetLength(lvRawBytes, Length(ASrc));   // 预留后面一个字符串结束标志
  lvSrcBytes := TEncoding.ANSI.GetBytes(ASrc);
  j := 0;  // 从0开始
  i := 0;
  while i <= Length(ASrc) do
  begin
    if (pvIsPostData) and (lvSrcBytes[i] = 43) then   //43(+) 号变成空格, Post的原始数据中如果有 空格时会变成 +号
    begin
      lvRawBytes[j] := 32; // Ord(' ');
    end else if lvSrcBytes[i] <> 37 then      //'%' = 37
    begin
      lvRawBytes[j] :=lvSrcBytes[i];
    end else
    begin
      Inc(i); // skip the % char
      try
      lvRawBytes[j] := StrToInt('$' +URLChar(lvSrcBytes[i]) + URLChar(lvSrcBytes[i+1]));
      except end;
      Inc(i, 1);  // 再跳过一个字符.

    end;
    Inc(i);
    Inc(j);
  end;
  SetLength(lvRawBytes, j);
  Result := TEncoding.ANSI.GetString(lvRawBytes);
  {$ELSE}
  SetLength(Result, Length(ASrc));   // 预留后面一个字符串结束标志
  j := 1;  // 从1开始
  i := 1;
  while i <= Length(ASrc) do
  begin
    if (pvIsPostData) and (ASrc[i] = '+') then   // + 号变成空格, Post的原始数据中如果有 空格时会变成 +号
    begin
      Result[j] := ' ';
    end else if ASrc[i] <> '%' then
    begin
      Result[j] := ASrc[i];
    end else 
    begin
      Inc(i); // skip the % char
      try
      Result[j] := URLChar(StrToInt('$' + ASrc[i] + ASrc[i+1]));
      except end;
      Inc(i, 1);  // 再跳过一个字符.

    end;
    Inc(i);
    Inc(j);
  end;
  SetLength(Result, j - 1);
  {$ENDIF}

end;




function URLEncode(S: URLString; pvIsPostData: Boolean = true): URLString;
var
  i: Integer; // loops thru characters in string
  {$IFDEF UNICODE_URL}
  lvRawBytes:TBytes;
  {$ELSE}
  lvRawStr:AnsiString;
  {$ENDIF}
begin
  {$IFDEF UNICODE_URL}
  lvRawBytes := TEncoding.ANSI.GetBytes(S);
  for i := 0 to Length(lvRawBytes) - 1 do
  begin
    case lvRawBytes[i] of
      //'A' .. 'Z', 'a'.. 'z', '0' .. '9', '-', '_', '.':
      65..90, 97..122, 48..57, 45, 95, 46:
        Result := Result + URLChar(lvRawBytes[i]);
      //' ':
      32:
        if pvIsPostData then
        begin     // Post数据如果是空格需要编码成 +
          Result := Result + '+';
        end else
        begin
          Result := Result + '%20';
        end
    else
      Result := Result + '%' + SysUtils.IntToHex(lvRawBytes[i], 2);
    end;
  end;
  {$ELSE}
  Result := '';
  lvRawStr := s;
  for i := 1 to Length(lvRawStr) do
  begin
    case lvRawStr[i] of
      'A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '.':
        Result := Result + lvRawStr[i];
      ' ':
        if pvIsPostData then
        begin     // Post数据如果是空格需要编码成 +
          Result := Result + '+';
        end else
        begin
          Result := Result + '%20';
        end
    else
      Result := Result + '%' + SysUtils.IntToHex(Ord(lvRawStr[i]), 2);
    end;
  end;
  {$ENDIF}
end;

function StringsValueOfName(pvStrings: TStrings; const pvName: string;
    pvSpliters: TSysCharSet; pvTrim: Boolean): String;
var
  i : Integer;
  s : string;
  lvName: String;
  p : PChar;
  lvSpliters:TSysCharSet;
begin
  lvSpliters := pvSpliters;
  Result := '';

  // context-length : 256
  for i := 0 to pvStrings.Count -1 do
  begin
    s := pvStrings[i];
    p := PChar(s);

    // 获取名称
    lvName := LeftUntil(p, lvSpliters);

    if pvTrim then lvName := Trim(lvName);

    if CompareText(lvName, pvName) = 0 then
    begin
      // 跳过分隔符
      SkipChars(p, lvSpliters);

      // 获取值
      Result := P;

      // 截取值
      if pvTrim then Result := Trim(Result);

      Exit;
    end;
  end;

end;

function StrStrIgnoreCase(P, PSub: PChar): PChar;
var
  I: Integer;
  lvSubUP: String;
begin
  Result := nil;
  if (P = nil) or (PSub = nil) then
    Exit;
  lvSubUP := UpperCase(PSub);
  PSub := PChar(lvSubUP);
  while P^ <> #0 do
  begin
    if UpperChar(P^) = PSub^ then
    begin
      I := 1;
      while PSub[I] <> #0 do
      begin
        if UpperChar(P[I]) = PSub[I] then
          Inc(I)
        else
          Break;
      end;
      if PSub[I] = #0 then
      begin
        Result := P;
        Break;
      end;
    end;
    Inc(P);
  end;
end;

function StrStr(P: PChar; PSub: PChar): PChar;
var
  I: Integer;
begin
{$IFDEF MSWINDOWS}
{$IFDEF UNICODE}
  if Assigned(VCStrStrW) then
  begin
    Result := VCStrStrW(P, PSub);
    Exit;
  end;
{$ELSE}
  if Assigned(VCStrStr) then
  begin
    Result := VCStrStr(P, PSub);
    Exit;
  end;
{$ENDIF}
{$ENDIF}

  if (PSub = nil) or (PSub^ = #0) then
    Result := P
  else
  begin
    Result := nil;
    while P^ <> #0 do
    begin
      if P^ = PSub^ then
      begin
        I := 1;     // 从后面第二个字符开始对比
        while PSub[I] <> #0 do
        begin
          if P[I] = PSub[I] then
            Inc(I)
          else
            Break;
        end;

        if PSub[I] = #0 then
        begin  // P1和P2已经匹配到了末尾(匹配成功)
          Result := P;
          Break;
        end;
      end;
      Inc(P);
    end;
  end;
end;

function LeftUntilStr(var P: PChar; pvSpliter: PChar; pvIgnoreCase: Boolean =
    true): string;
var
  lvPUntil:PChar;
  l : Integer;
begin
  if pvIgnoreCase then
  begin
    lvPUntil := StrStrIgnoreCase(P, pvSpliter);
  end else
  begin
    lvPUntil := StrStr(P, pvSpliter);
  end;
  if lvPUntil = nil then
  begin
    Result := '';
    //P := nil;
    // 匹配失败不移动P
  end else
  begin
    l := lvPUntil-P;
    if l = 0 then
    begin
      Result := '';
    end else
    begin
      SetLength(Result, l);
      if SizeOf(Char) = 1 then
      begin
        Move(P^, PChar(Result)^, l);
      end else
      begin
        l := l shl 1;
        Move(P^, PChar(Result)^, l);
      end;
      P := lvPUntil;
    end;
  end;
  

end;

function SearchPointer(pvSource: Pointer; pvSourceLen, pvStartIndex: Integer;
    pvSub: Pointer; pvSubLen: Integer): Pointer;
var
  I, j: Integer;
  lvTempP, lvTempPSub, lvTempP2, lvTempPSub2:PByte;
begin
  if (pvSub = nil) then
    Result := nil
  else
  begin
    Result := nil;
    j := pvStartIndex;
    lvTempP := PByte(pvSource);
    Inc(lvTempP, pvStartIndex);

    lvTempPSub := PByte(pvSub);
    while j<pvSourceLen do
    begin
      if lvTempP^ = lvTempPSub^ then
      begin


        // 临时指针，避免移动顺序比较指针
        lvTempP2 := lvTempP;
        Inc(lvTempP2);    // 移动到第二位(前一个已经进行了比较
        I := 1;           // 初始化计数器(从后面第二个字符开始对比)

        // 临时比较字符指针
        lvTempPSub2 := lvTempPSub;
        Inc(lvTempPSub2);  // 移动到第二位(前一个已经进行了比较

        while (I < pvSubLen) do
        begin
          if lvTempP2^ = lvTempPSub2^ then
          begin
            Inc(I);
            inc(lvTempP2);   // 移动到下一位进行比较
            inc(lvTempPSub2);
          end else
            Break;
        end;

        if I = pvSubLen then
        begin  // P1和P2已经匹配到了末尾(匹配成功)
          Result := lvTempP;
          Break;
        end;
      end;
      Inc(lvTempP);
      inc(j);
    end;
  end;
end;


function SkipStr(var P:PChar; pvSkipStr: PChar; pvIgnoreCase: Boolean = true):
    Integer;
var
  lvSkipLen : Integer;
begin
  Result := 0;

  lvSkipLen := Length(pvSkipStr) * SizeOf(Char);

  while True do
  begin
    if StartWith(P, pvSkipStr) then
    begin
      Inc(Result);
      P := PChar(IntPtr(P) + lvSkipLen);
    end else
    begin
      Break;
    end;    
  end; 
end;

function StartWith(P:PChar; pvStart:PChar; pvIgnoreCase: Boolean = true):
    Boolean;
var
  lvSubUP: String;
  PSubUP : PChar;
begin
  Result := False;

  if pvIgnoreCase then
  begin
    lvSubUP := UpperCase(pvStart^);
    PSubUP := PChar(lvSubUP);
    if (P = nil) or (PSubUP = nil) then  Exit;
    
    if P^ = #0 then Exit;
    while PSubUP^ <> #0 do
    begin
      if UpperChar(P^) = PSubUP^ then
      begin
        Inc(P);
        Inc(PSubUP);
      end else
        Break;
    end;
    if PSubUP^ = #0 then  // 比较到最后
    begin
      Result := true;
    end;

  end else
  begin
    Result := CompareMem(P, pvStart, Length(pvStart));
  end;
end;

function SplitStr(s:string; pvSpliterStr:string; var s1, s2:String): Boolean;
var
  pSource, pSpliter:PChar;
  lvTemp:string;
begin
  pSource := PChar(s);

  pSpliter := PChar(pvSpliterStr);

  // 跳过开头的分隔符
  SkipStr(pSource, pSpliter);

  lvTemp := LeftUntilStr(pSource, pSpliter);
  if lvTemp <> '' then
  begin
    Result := true;
    s1 := lvTemp;
    // 跳过开头的分隔符
    SkipStr(pSource, pSpliter);
    s2 := pSource;
  end else
  begin
    Result := False;
  end;  

end;

function StringToUtf8Bytes(pvData:String; pvBytes:TBytes): Integer;
{$IFNDEF UNICODE}
var
  lvRawStr:AnsiString;
{$ENDIF}
begin
{$IFDEF UNICODE}
  Result := TEncoding.UTF8.GetBytes(pvData, 1, Length(pvData), pvBytes, 0);
{$ELSE}
  lvRawStr := UTF8Encode(pvData);
  Result := Length(lvRawStr);
  Move(PAnsiChar(lvRawStr)^, pvBytes[0], Result);
{$ENDIF}
end;

function Utf8BytesToString(pvBytes: TBytes; pvOffset: Cardinal): String;
{$IFNDEF UNICODE}
var
  lvRawStr:AnsiString;
  l:Cardinal;
{$ENDIF}
begin
{$IFDEF UNICODE}
  Result := TEncoding.UTF8.GetString(pvBytes, pvOffset, Length(pvBytes) - pvOffset);
{$ELSE}
  l := Length(pvBytes) - pvOffset;
  SetLength(lvRawStr, l);
  Move(pvBytes[pvOffset], PansiChar(lvRawStr)^, l);
  Result := UTF8Decode(lvRawStr);
{$ENDIF}
end;

function StringToUtf8Bytes(pvData:string): TBytes; overload;
{$IFNDEF UNICODE}
var
  lvRawStr:AnsiString;
{$ENDIF}
begin
{$IFDEF UNICODE}
  Result := TEncoding.UTF8.GetBytes(pvData);
{$ELSE}
  lvRawStr := UTF8Encode(pvData);
  SetLength(Result, Length(lvRawStr));
  Move(PAnsiChar(lvRawStr)^, Result[0], Length(lvRawStr));
{$ENDIF}
end;


initialization

{$IFDEF MSWINDOWS}
hMsvcrtl := LoadLibrary('msvcrt.dll');
if hMsvcrtl <> 0 then
begin
  VCStrStr := TMSVCStrStr(GetProcAddress(hMsvcrtl, 'strstr'));
  VCStrStrW := TMSVCStrStrW(GetProcAddress(hMsvcrtl, 'wcsstr'));
  VCMemCmp := TMSVCMemCmp(GetProcAddress(hMsvcrtl, 'memcmp'));
end
else
begin
  VCStrStr := nil;
  VCStrStrW := nil;
  VCMemCmp := nil;
end;
{$ENDIF}

finalization

{$IFDEF MSWINDOWS}
if hMsvcrtl <> 0 then
  FreeLibrary(hMsvcrtl);
{$ENDIF}

end.
