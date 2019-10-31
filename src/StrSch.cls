VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StrSch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'-----------------------------------------------------------------------------------------------------
'
' [Hidennotare] v2
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/Hidennotare
' author:relaxtools@opensquare.net
'
' The MIT License (MIT)
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
'
'-----------------------------------------------------------------------------------------------------
'>### StrSch �N���X
'>
'>**Remarks**
'>
'>�����񌟍�<br>
'>���K�\�������ƌ݊������������N���X<br>
'>**���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B**
'>
'>**Dependent**
'>
'>* MatchBean
'>
'>**History**
'>
'>|Date|Version|Note|
'>|---|---|---|
'>|2018-12-16|Ver.1.0.0|�V�K�쐬|
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit
'>---
'>#### Test(StrSch)
'>
'>**Syntax**
'>
'>```
'>flg = StrSch.Test(strText,
'>                  strExp,
'>                  [blnIgnoreCase = False],
'>                  [blnMatchByte = False],
'>                  [blnWhole = False])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|strText|�K�{|String|�����^�[�Q�b�g�̕�������w��|
'>|strExp|�K�{|String|�����p�^�[�����w��|
'>|blnIgnoreCase|�ȗ���|Boolean|�啶���Ə���������ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnMatchByte|�ȗ���|Boolean|�S�p�Ɣ��p����ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnWhole|�ȗ���|Boolean|���S��v�̏ꍇTrue�A������v�̏ꍇ��False�A�f�t�H���g�l��False|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|flg|Boolean|�}�b�`:True / �A���}�b�`:False|
'>
'>**Remarks**
'>
'>������̌���<br>
'>�w�肳�ꂽ��������������A�p�^�[���Ɉ�v���镶���񂪌������ꂽ���ǂ���������<br>
'>�u�[�� (Boolean) �l��Ԃ��܂��B
'>
'>**Example**
'>
'>**See also**
'>
'>* RegExp.Test
'>
Function Test(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As Boolean

    Dim strCmp1 As String
    Dim strCmp2 As String
    
    strCmp1 = strText
    strCmp2 = strExp

    If blnIgnoreCase Then
        strCmp1 = UCase(strCmp1)
        strCmp2 = UCase(strCmp2)
    End If

    If blnMatchByte Then
        strCmp1 = StrConv(strCmp1, vbNarrow)
        strCmp2 = StrConv(strCmp2, vbNarrow)
    End If

    If blnWhole Then
        Test = (strCmp1 = strCmp2)
    Else
        Test = (InStr(strCmp1, strCmp2) > 0)
    End If

End Function
'>---
'>#### Replace(StrSch)
'>
'>**Syntax**
'>
'>```
'>ret = StrSch.Replace(strText,
'>                     strExp,
'>                     strReplace,
'>                     [blnIgnoreCase = False],
'>                     [blnMatchByte = False],
'>                     [blnWhole = False])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|strText|�K�{|String|�����^�[�Q�b�g�̕�������w��|
'>|strExp|�K�{|String|�����p�^�[�����w��|
'>|strReplace|�K�{|String|�u����������w��|
'>|blnIgnoreCase|�ȗ���|Boolean|�啶���Ə���������ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnMatchByte|�ȗ���|Boolean|�S�p�Ɣ��p����ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnWhole|�ȗ���|Boolean|���S��v�̏ꍇTrue�A������v�̏ꍇ��False�A�f�t�H���g�l��False|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|ret|String|�u����̕�����|
'>
'>**Remarks**
'>
'>������̒u��<br>
'>�w�肳�ꂽ��������������A�p�^�[���Ɉ�v���镶���񂪎w�蕶����Œu��<br>
'>
'>**Example**
'>
'>**See also**
'>
'>* RegExp.Replace
'>
Function Replace(ByVal strText As String, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As String
    
    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long
    Dim strL As String
    Dim strR As String
    Dim strBuf As String

    '����
    Set col = Me.Execute(strText, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
    
    strBuf = strText
    '�u�������Index�������̂ŋt���ɏ���
    For i = col.Count To 1 Step -1
    
        Set bean = col(i)
    
        strL = Mid$(strBuf, 1, bean.Index - 1)
        strR = Mid$(strBuf, bean.Index + bean.Length)

        strBuf = strL & strReplace & strR
    
    Next
    
    Replace = strBuf
    
End Function
'>---
'>#### Execute(StrSch)
'>
'>**Syntax**
'>
'>```
'>Set ret = StrSch.Execute(strText,
'>                         strExp,
'>                         [blnIgnoreCase = False],
'>                         [blnMatchByte = False],
'>                         [blnWhole = False])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|strText|�K�{|String|�����^�[�Q�b�g�̕�������w��|
'>|strExp|�K�{|String|�p�^�[�����w��|
'>|blnIgnoreCase|�ȗ���|Boolean|�啶���Ə���������ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnMatchByte|�ȗ���|Boolean|�S�p�Ɣ��p����ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnWhole|�ȗ���|Boolean|���S��v�̏ꍇTrue�A������v�̏ꍇ��False�A�f�t�H���g�l��False|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|ret|Collection<MatchBean>|Collection<MatchBean>��ԋp|
'>
'>**Remarks**
'>
'>������̌���<br>
'>�w�肳�ꂽ��������������A�p�^�[���Ɉ�v���镶���񂪌������ꂽ���ǂ���������<br>
'>Collection��Ԃ��܂��B
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* StdSch.Execute
'>
Public Function Execute(ByVal strText As String, ByVal strExp As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False) As Collection

    Dim col As Collection
    Dim lngPos As Long
    Dim strResult As String
    Dim MB As MatchBean
    
    Set col = New Collection
    
    Dim strCmp1 As String
    Dim strCmp2 As String
    
    strCmp1 = strText
    strCmp2 = strExp

    If blnIgnoreCase Then
        strCmp1 = UCase(strCmp1)
        strCmp2 = UCase(strCmp2)
    End If

    If blnMatchByte Then
        strCmp1 = StrConv(strCmp1, vbNarrow)
        strCmp2 = StrConv(strCmp2, vbNarrow)
    End If
    
    If blnWhole Then
    
        If strCmp1 = strCmp2 Then
        
            Set MB = New MatchBean
            
            MB.Index = 1
            MB.Length = Len(strCmp1)
            MB.Value = strCmp1
        
            col.Add MB
        
        End If
    
    Else
    
        '�p�^�[�����󔒂̏ꍇ�A�S��v�Ƃ���B
        If strCmp2 = "" Then
        
            Set MB = New MatchBean
            
            MB.Index = 1
            MB.Length = 0
            MB.Value = strCmp1
        
            col.Add MB
        Else
    
            lngPos = InStr(strCmp1, strCmp2)
            
            Do Until lngPos = 0
                
                strResult = Mid$(strText, lngPos, Len(strExp))
                
                Set MB = New MatchBean
                
                MB.Index = lngPos
                MB.Length = Len(strResult)
                MB.Value = strResult
            
                col.Add MB
            
                lngPos = InStr(lngPos + 1, strCmp1, strCmp2)
            Loop
        End If
    End If
    
    Set Execute = col

End Function
'>---
'>#### Check(StrSch)
'>
'>**Syntax**
'>
'>```
'>flg = StrSch.Check(strExp)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|strExp|�K�{|String|�����p�^�[�����w��|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|flg|Boolean|���True��ԋp|
'>
'>**Remarks**
'>
'>����������̃`�F�b�N<br>
'>���K�\��(RegExp.Check)�Ƃ̌݊����̂��߂̃��\�b�h<br>
'>�u�[�� (Boolean) �l��Ԃ��܂��B
'>
'>**Example**
'>
'>**See also**
'>
'>* RegExp.Test
'>
Function Check(ByVal strExp As String)
    Check = False
End Function
'>---
'>#### ReplaceShape(StrSch)
'>
'>**Syntax**
'>
'>```
'>StrSch.ReplaceShape sh,
'>                    strText,
'>                    strExp,
'>                    strReplace,
'>                    [blnIgnoreCase = False],
'>                    [blnMatchByte = False],
'>                    [blnWhole = False]
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|sh|�K�{|Shape|�u������Shepe���w��|
'>|strText|�K�{|String|�����^�[�Q�b�g�̕�������w��|
'>|strExp|�K�{|String|�����p�^�[�����w��|
'>|strReplace|�K�{|String|�u����������w��|
'>|blnIgnoreCase|�ȗ���|Boolean|�啶���Ə���������ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnMatchByte|�ȗ���|Boolean|�S�p�Ɣ��p����ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnWhole|�ȗ���|Boolean|���S��v�̏ꍇTrue�A������v�̏ꍇ��False�A�f�t�H���g�l��False|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>Shape��Replace(�����ێ�Ver)<br>
'>�w�肳�ꂽ��������������A�p�^�[���Ɉ�v���镶���񂪎w�蕶����Œu��<br>
'>
'>**Example**
'>
'>**See also**
'>
'>* RegExp.ReplaceShape
'>
Sub ReplaceShape(ByRef sh As Shape, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With sh.TextFrame2.TextRange

        '����
        Set col = Me.Execute(.Text, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
        
        '�u�������Index�������̂ŋt���ɏ���
        For i = col.Count To 1 Step -1
        
            Set bean = col(i)
        
            Call .Characters(bean.Index, bean.Length).Delete
            
            If strReplace <> "" Then
                Call .Characters(bean.Index, 0).InsertAfter(strReplace)
            End If
        
        Next
    
    End With

End Sub
'>---
'>#### ReplaceRange(StrSch)
'>
'>**Syntax**
'>
'>```
'>StrSch.ReplaceRange rng,
'>                    strText,
'>                    strExp,
'>                    strReplace,
'>                    [blnIgnoreCase = False],
'>                    [blnMatchByte = False],
'>                    [blnWhole = False]
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|rng|�K�{|Range|�u������Range���w��|
'>|strText|�K�{|String|�����^�[�Q�b�g�̕�������w��|
'>|strExp|�K�{|String|�����p�^�[�����w��|
'>|strReplace|�K�{|String|�u����������w��|
'>|blnIgnoreCase|�ȗ���|Boolean|�啶���Ə���������ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnMatchByte|�ȗ���|Boolean|�S�p�Ɣ��p����ʂ��Ȃ��ꍇ��True�A�f�t�H���g�l��False|
'>|blnWhole|�ȗ���|Boolean|���S��v�̏ꍇTrue�A������v�̏ꍇ��False�A�f�t�H���g�l��False|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>Range��Replace(�����ێ�Ver)<br>
'>�w�肳�ꂽ��������������A�p�^�[���Ɉ�v���镶���񂪎w�蕶����Œu��<br>
'>
'>**Example**
'>
'>**See also**
'>
'>* RegExp.ReplaceRange
'>
Sub ReplaceRange(ByRef rng As Range, ByVal strExp As String, ByVal strReplace As String, Optional ByVal blnIgnoreCase As Boolean = False, Optional ByVal blnMatchByte As Boolean = False, Optional ByVal blnWhole As Boolean = False)

    Dim col As Collection
    Dim bean As MatchBean
    Dim i As Long

    With rng

        '����
        Set col = Me.Execute(.Value, strExp, blnIgnoreCase, blnMatchByte, blnWhole)
        
        '�u�������Index�������̂ŋt���ɏ���
        For i = col.Count To 1 Step -1
        
            Set bean = col(i)
        
            Call .Characters(bean.Index, bean.Length).Delete
            
            If strReplace <> "" Then
                Call .Characters(bean.Index, 0).Insert(strReplace)
            End If
        
        Next
    
    End With

End Sub