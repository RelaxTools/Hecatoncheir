VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CollectionCursor"
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
' �J�[�\�����R���N�V�����ǂݍ��݃N���X
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements ICursor

Private mCol As Collection
Private mIndex As Long
'------------------------------------------------------
' �R���X�g���N�^
'------------------------------------------------------
Private Function IConstructor_Instancing(ByRef Args As Collection) As Object

    Const C_COLLECTION As Long = 1
    
    If Args.Count <> 1 Then
        Exit Function
    End If
    
    If Not TypeOf Args(C_COLLECTION) Is Collection Then
        Exit Function
    End If
    
    Set mCol = Args(C_COLLECTION)

    ICursor_MoveFirst
    
    Set IConstructor_Instancing = Me
    
End Function
Private Sub Class_Initialize()
    mIndex = 0
End Sub
Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub
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
    
    If mCol Is Nothing Then
        ICursor_Eof = True
        Exit Sub
    End If
    
    ICursor_Eof = mCol.Count < mIndex

End Property
'------------------------------------------------------
' ���ڎ擾
'------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    
    If ICursor_Eof Then
        'EOF��͍Ō�̒l��Ԃ�
        If IsObject(mCol(mCol.Count)) Then
            Set ICursor_Item = mCol(mCol.Count)
        Else
            ICursor_Item = mCol(mCol.Count)
        End If
    Else
        If IsObject(mCol(mIndex)) Then
            Set ICursor_Item = mCol(mIndex)
        Else
            ICursor_Item = mCol(mIndex)
        End If
    End If

End Property
'------------------------------------------------------
' �O���ڎ擾
'------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant

    If IsObject(mCol(mIndex - 1)) Then
        Set ICursor_PreviousItem = mCol(mIndex - 1)
    Else
        ICursor_PreviousItem = mCol(mIndex - 1)
    End If

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
