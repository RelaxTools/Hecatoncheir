VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CharCursor"
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
' �J�[�\����������ǂݍ��݃N���X
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements ICursor

Private mBuf As String
Private mIndex As Long
Private Sub Class_Initialize()
    mIndex = 1
End Sub
'------------------------------------------------------
' �R���X�g���N�^
'------------------------------------------------------
Private Function IConstructor_Instancing(ByRef Args As Collection) As Object

    Select Case Args.Count
        Case 1
            mBuf = CStr(Args(1))
            ICursor_MoveFirst
        Case Else
            '�G���[
            Exit Function
    End Select
    
    Set IConstructor_Instancing = Me
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
    ICursor_Eof = Len(mBuf) < mIndex
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
'------------------------------------------------------
' �����擾(�����ɂđO��̕������擾�j
'------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant

    Dim lngPos As Long
    
    If IsMissing(opt) Then
        opt = 0
    End If
    
    lngPos = mIndex + opt

    If lngPos < 1 Or lngPos > Len(mBuf) Then
        ICursor_Item = ""
    Else
        ICursor_Item = Mid$(mBuf, lngPos, 1)
    End If

End Property
'------------------------------------------------------
' �O�̕����擾
'------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    
    Dim lngPos As Long
    
    lngPos = mIndex - 1

    If lngPos < 1 Or lngPos > Len(mBuf) Then
        ICursor_PreviousItem = ""
    Else
        ICursor_PreviousItem = Mid$(mBuf, lngPos, 1)
    End If

End Property