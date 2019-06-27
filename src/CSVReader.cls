VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSVReader"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [Hecatoncheir] v1
'
' Copyright (c) 2019 Yasuhiro Watanabe
' https://github.com/RelaxTools/Hecatoncheir
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
' �ˑ����W���[��
'   IConstructor.cls
'   TextReader.cls
'   ICursor.cls
'   IReader.cls
'-----------------------------------------------------------------------------------------------------
' 2018-12-06 Ver.1.0.0 �V�K�쐬 CSV���̓N���X
'-----------------------------------------------------------------------------------------------------

Option Explicit
Implements IConstructor
Implements ICursor
Implements IReader

Private IR As IReader

Private mFileName As String
Private mNewLineCode As NewLineCodeConstants
Private mEncode As EncodeConstants

Private mDelimiter As String
Private mQuotation As Boolean

Private mList As Collection
Private mIndex As Long
'--------------------------------------------------------------
'�@�R���X�g���N�^
'--------------------------------------------------------------
Private Function IConstructor_Instancing(Args As Collection) As Object
    
    If Args.Count = 0 Then
        Exit Function
    End If
    
    'Default
    mNewLineCode = NewLineCodeConstants.CRLF
    mEncode = EncodeConstants.CP932
    
    mDelimiter = ","
    mQuotation = False
    
    If Args.Count >= 1 Then
        mFileName = Args(1)
    End If
    
    If Args.Count >= 2 Then
        mNewLineCode = Args(2)
    End If
    
    If Args.Count >= 3 Then
        mEncode = Args(3)
    End If
    
    If Args.Count >= 4 Then
        mDelimiter = Args(4)
    End If
    
    If Args.Count >= 5 Then
        mQuotation = Args(5)
    End If
    
    'TextReader�ɈϏ�����B�R�[�e�[�V��������̏ꍇ�ɂ͉��s�R�[�h��CsvReader���Ńp�[�X����B
    If mQuotation Then
        Set IR = Constructor(New TextReader, mFileName, NewLineCodeConstants.None, mEncode)
    Else
        Set IR = Constructor(New TextReader, mFileName, mNewLineCode, mEncode)
    End If
    
    Set mList = CsvParser(IR.ReadAll)
    
    ICursor_MoveFirst
    
    Set IConstructor_Instancing = Me
    
End Function
Private Sub Class_Terminate()
    Set IR = Nothing
End Sub
'--------------------------------------------------------------
'�@CSV�p�[�T�[
'--------------------------------------------------------------
Private Function CsvParser(ByVal strBuf As String) As Collection

    Const C_QUAT As String = """"
    Dim IC As ICursor
    Dim sw As Boolean
    Dim blnLineBreak As Boolean
    Dim blnItemBreak As Boolean
    Dim col As Collection
    Dim row As Collection
    Dim lngQuot As Long
    
    lngQuot = 0
    
    sw = False
    
    Set row = New Collection
    
    Set IC = Constructor(New CharCursor, strBuf)
    Do Until IC.Eof
        
        '������
        Set col = New Collection
        blnLineBreak = False

        Do Until IC.Eof Or blnLineBreak
        
            '������
            Dim sb As StringBuilder
            Set sb = New StringBuilder
            blnItemBreak = False
            
            Do Until IC.Eof Or blnLineBreak Or blnItemBreak

                Select Case IC.Item
                    Case C_QUAT

                        '�R�[�e�[�V��������̏ꍇ
                        If mQuotation Then

                            lngQuot = lngQuot + 1

                            If sw Then

                                '���̕�����Quatation
                                If IC.Item(1) = C_QUAT Then
                                    lngQuot = lngQuot + 1
                                    sb.Append C_QUAT
                                    IC.MoveNext
                                Else
                                    sw = False
                                End If

                            Else
                                sw = True
                            End If
                        End If

                    Case vbCr

                        If sw Then
                            sb.Append IC.Item
                        End If

                    Case vbLf

                        If sw Then
                            sb.Append IC.Item
                        Else
                            blnLineBreak = True
                        End If

                    Case mDelimiter

                        If sw Then
                            sb.Append IC.Item
                        Else
                            blnItemBreak = True
                        End If

                    Case Else

                        sb.Append IC.Item

                End Select
            
                IC.MoveNext
            Loop
            
            '��ǉ�����
            col.Add sb.ToString
            
        Loop
        
        '�s�ǉ�����
        row.Add col
        
    Loop
    
    '�_�u���R�[�e�[�V�����������ł͂Ȃ��ꍇ
    If lngQuot Mod 2 <> 0 Then
        Message.Throw 1, Me, "CsvParser", "Invalid Format(Quotation)"
    End If
    
    Set CsvParser = row
    
End Function
'--------------------------------------------------------------
'�@�z��ǂݍ���
'--------------------------------------------------------------
Private Function IReader_ReadAll() As Variant

    Set IReader_ReadAll = mList

End Function
'--------------------------------------------------------------
' ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Public Property Get GetCursor() As ICursor
    Set GetCursor = Me
End Property
'------------------------------------------------------
' �I������
'------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    
    If mList Is Nothing Then
        ICursor_Eof = True
        Exit Sub
    End If
    
    ICursor_Eof = mList.Count < mIndex

End Property
'------------------------------------------------------
' ���ڎ擾
'------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant

    If ICursor_Eof Then
        'EOF��͍Ō�̒l��Ԃ�
        If IsObject(mList.Item(mList.Count)(opt)) Then
            Set ICursor_Item = mList.Item(mList.Count)(opt)
        Else
            ICursor_Item = mList.Item(mList.Count)(opt)
        End If
    Else
        If IsObject(mList.Item(mIndex)(opt)) Then
            Set ICursor_Item = mList.Item(mIndex)(opt)
        Else
            ICursor_Item = mList.Item(mIndex)(opt)
        End If
    End If

End Property
'------------------------------------------------------
' �O���ڎ擾
'------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant

    Message.Throw 1, Me, "ICursor_PreviousItem", "Not Supported Property"
'    If IsMissing(opt) Then
'        If IsObject(mList(mIndex - 1)) Then
'            Set ICursor_PreviousItem = mList(mIndex - 1)
'        Else
'            ICursor_PreviousItem = mList(mIndex - 1)
'        End If
'    Else
'        If IsObject(mList(mIndex - 1)(opt)) Then
'            Set ICursor_PreviousItem = mList(mIndex - 1)(opt)
'        Else
'            ICursor_PreviousItem = mList(mIndex - 1)(opt)
'        End If
'    End If
    
End Property
'------------------------------------------------------
' �ŏ��̍s�Ɉړ�
'------------------------------------------------------
Private Sub ICursor_MoveFirst()
    mIndex = 1
End Sub

'------------------------------------------------------
' ���s�擾
'------------------------------------------------------
Private Sub ICursor_MoveNext()
    mIndex = mIndex + 1
End Sub

