VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ArrayList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
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
' ���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B�z��֌W�̃��\�b�h������܂��B
'-----------------------------------------------------------------------------------------------------
' ArrayList �N���X Collection ���x�[�X�ɂ��Ă��邪�A�Y����0����Ȃ̂Œ���
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IConstructor
Implements ICursor
Implements IList

Private mCol As Collection
Private v() As Variant
Private mIndex As Long
'--------------------------------------------------------------
' Initialize
'--------------------------------------------------------------
Private Sub Class_Initialize()
    Set mCol = New Collection
    mIndex = 0
End Sub
'--------------------------------------------------------------
' Terminate
'--------------------------------------------------------------
Private Sub Class_Terminate()
    Set mCol = Nothing
End Sub
'--------------------------------------------------------------
' IConstructor I/F
'--------------------------------------------------------------
' �R���X�g���N�^
'--------------------------------------------------------------
Private Function IConstructor_Instancing(ByRef Args As Collection) As Object

    Dim v As Variant
    Dim i As Long
    
    Select Case Args.Count
        
        '�����Ȃ�
        Case 0
        
        '�����P��
        Case 1
            Select Case True
                
                '�R���N�V��������̕ϊ�
                Case TypeOf Args(1) Is Collection
                    Call IList_Clear
                    Set mCol = Args(1)
                
                '�P�����z�񂩂�̕ϊ�
                Case IsArray(Args(1))
                    Call IList_Clear
                    For i = LBound(Args(1)) To UBound(Args(1))
                        mCol.Add Args(1)(i)
                    Next
                Case Else
                    '�G���[
                    Exit Function
            End Select
        
        '��������̒ǉ�
        Case Else
            Call IList_Clear
            For Each v In Args
                mCol.Add v
            Next
    End Select
    
    Set IConstructor_Instancing = Me
    
End Function
'--------------------------------------------------------------
' Static ���\�b�h
'--------------------------------------------------------------
' ��z��Ή� IsArray
'---------------------------------------------------------------------
' Dim a() As Variant --> Error 9 �C���f�b�N�X���L���͈͂ɂ���܂���B
' a = Array() --> Ubound �� -1
'---------------------------------------------------------------------
Public Function IsArray(v As Variant) As Boolean

    On Error GoTo e

    IsArray = False

    If VBA.IsArray(v) Then
        IsArray = IIf(UBound(v) < LBound(v), False, True)
    Else
        IsArray = False
    End If

e:
    Exit Function

End Function
'-------------------------------------------
' Static ���\�b�h
'-------------------------------------------
' �G���[���m�t�� Ubound
'-------------------------------------------
Public Function TryUBound(ary As Variant, lngIdx As Long, Optional ByVal dimension As Long = 1) As Boolean
 
    On Error GoTo e
    
    lngIdx = UBound(ary, dimension)

    TryUBound = True
    
    Exit Function
e:
    TryUBound = False

End Function
'-------------------------------------------
' Static ���\�b�h
'-------------------------------------------
' �G���[���m�t�� Lbound
'-------------------------------------------
Public Function TryLBound(ary As Variant, lngIdx As Long, Optional ByVal dimension As Long = 1) As Boolean
 
    On Error GoTo e
    
    lngIdx = LBound(ary, dimension)

    TryLBound = True
    
    Exit Function
e:
    TryLBound = False

End Function
'--------------------------------------------------------------
' ArrayList ����S�Ă̍��ڂ��폜����B
'--------------------------------------------------------------
Private Sub IList_Clear()

    Set mCol = New Collection
    mIndex = 0
    
End Sub
'--------------------------------------------------------------
' ArrayList �ɍ��ڂ�ǉ�����B
'--------------------------------------------------------------
Private Sub IList_Add(obj As Variant)
    
    mCol.Add obj

End Sub
'--------------------------------------------------------------
' ArrayList �̎w��ʒu�ɍ��ڂ�ǉ�����B
'--------------------------------------------------------------
Private Sub IList_Insert(Idx As Long, v As Variant)

    If Idx < 0 Or Idx >= mCol.Count Then
        Message.Throw 1, Me, "Insert", "IndexOutOfRangeException"
    End If
    
    mCol.Add v, , Idx + 1

End Sub
'--------------------------------------------------------------
' For Each �p
'--------------------------------------------------------------
Private Function IList_NewEnum() As stdole.IUnknown
    Set IList_NewEnum = mCol.[_NewEnum]
End Function
'--------------------------------------------------------------
' ArrayList �v�f����ԋp
'--------------------------------------------------------------
Private Property Get IList_Count() As Long
    IList_Count = mCol.Count
End Property
'--------------------------------------------------------------
' ArrayList �̎w��ʒu�̍��ڂ��擾
'--------------------------------------------------------------
Private Property Get IList_Item(Idx As Long) As Variant
    
    If Idx < 0 Or Idx >= mCol.Count Then
        Message.Throw 1, Me, "Item", "IndexOutOfRangeException"
    End If

    If VBA.IsObject(mCol.Item(Idx + 1)) Then
        Set IList_Item = mCol.Item(Idx + 1)
    Else
        IList_Item = mCol.Item(Idx + 1)
    End If
    
End Property
'--------------------------------------------------------------
' ArrayList �̎w��ʒu�̍��ڂ��폜
'--------------------------------------------------------------
Private Sub IList_RemoveAt(Idx As Long)
    
    If Idx < 0 Or Idx >= mCol.Count Then
        Message.Throw 1, Me, "RemoveAt", "IndexOutOfRangeException"
    End If
    
    mCol.Remove Idx + 1
End Sub
'--------------------------------------------------------------
' ArrayList �̃\�[�g
'--------------------------------------------------------------
Private Sub IList_Sort(Optional ByVal CP As IComparer = Nothing)

    Dim i As Long
    Dim j As Long
    Dim col2 As Collection
    Dim blnFind As Boolean
    
    If CP Is Nothing Then
        'Interface�����ʂ̃N���X�Ȃ̂�Default��r�Ƃ��ė��p
        Set CP = New IComparer
    End If
    
    'Collection����Ȃ�Ȃɂ����Ȃ�
    If mCol Is Nothing Then
        Exit Sub
    End If

    'Collection�̗v�f�����O�܂��͂P�̏ꍇ�\�[�g�s�v
    If mCol.Count <= 1 Then
        Exit Sub
    End If
    
    Set col2 = New Collection
    
    For i = 1 To mCol.Count
        If col2.Count = 0 Then
            col2.Add mCol(i)
        Else
            blnFind = False
            For j = col2.Count To 1 Step -1
    
                '�t�@�C���̕����傫�������ꍇ�A���̌�ɑ}���B
                If CP.Compare(mCol(i), col2(j)) >= 0 Then
                    col2.Add mCol(i), , , j
                    blnFind = True
                    Exit For
                End If
            Next
            If Not blnFind Then
                col2.Add mCol(i), , 1
            End If
        End If
    
    Next
    
    Set mCol = col2
    Set col2 = Nothing

End Sub
'--------------------------------------------------------------
' ArrayList ���P�`�Q�����z��ɕϊ�
'--------------------------------------------------------------
Private Function IList_ToArray() As Variant

    Dim v As Variant
    Dim s As Variant
    Dim lngRow As Long
    Dim lngCol As Long
    Dim i As Long
    Dim j As Long
    Dim result() As Variant
    Dim list As IList
    
    lngRow = mCol.Count
    lngCol = 0
    
    Set list = Me
    
    'ArrayList/ArrayList �̂Q������z��
    For Each v In list
        If TypeName(v) = "ArrayList" Then
            If lngCol < v.Count Then
                lngCol = v.Count
            End If
        End If
    Next

    Select Case True
        Case lngRow = 0
    
            IList_ToArray = Empty

        '1D�̏ꍇ
        Case lngRow > 0 And lngCol = 0
        
            ReDim result(0 To lngRow - 1)
        
            For i = 0 To list.Count - 1
                If IsObject(list(i)) Then
                    Set result(i) = list(i)
                Else
                    Let result(i) = list(i)
                End If
            Next
    
            IList_ToArray = result
        
        '2D�̏ꍇ
        Case lngRow > 0 And lngCol > 0
        
            ReDim result(0 To lngRow - 1, 0 To lngCol - 1)
        
            For i = 0 To list.Count - 1
                For j = 0 To list(i).Count - 1
                    If IsObject(list(i)(j)) Then
                        Set result(i, j) = list(i)(j)
                    Else
                        Let result(i, j) = list(i)(j)
                    End If
                Next
            Next
    
            IList_ToArray = result
    End Select
    
End Function
'--------------------------------------------------------------
' ArrayList ��Collection�ɕϊ�
'--------------------------------------------------------------
Private Function IList_ToCollection() As Collection
    
    Set IList_ToCollection = mCol

End Function
'--------------------------------------------------------------
' ArrayList ��JSON�ɕϊ�
'--------------------------------------------------------------
Private Function IList_ToString() As String
    Const PROC_NAME As String = "ToString"

    Dim v As Variant
    Dim sb As StringBuilder
    Set sb = New StringBuilder
    
    For Each v In mCol
    
        Select Case True
            Case IsObject(v), VarType(v) = vbDataObject
                
                sb.Append v.ToString
            
            Case IsEmpty(v)
                
                sb.Append "null"
            
            Case Else
                Select Case VarType(v)
                    
                    Case vbBoolean
        
                        sb.Append LCase(CStr(v))
        
                    Case vbString
                    
                        sb.Append Escape(v)
                    
                    Case vbByte, vbInteger, vbLong, vbSingle, vbDouble, vbCurrency, vbDecimal ', vbLongLong
        
                        sb.Append v
        
                    Case Else
        
                        '�G���[
                        Message.Throw 1, Me, "ToString", "not cast type ""{0}""", TypeName(v)
        
                End Select
        End Select
        
    Next

    IList_ToString = "[" & sb.ToJoin(", ") & "]"

End Function
'--------------------------------------------------------------
' ���䕶���ϊ�
'---------------------------------------------------------------------
Private Function Escape(ByVal v As String) As String

    Escape = """" & Convert.Escape(v) & """"

End Function
'Unicode
Private Function Unicode(ByVal strBuf As String) As Long
    Dim bytBuf() As Byte
    
    If Len(strBuf) <> 0 Then
        bytBuf = strBuf
        Unicode = CLng(bytBuf(1)) * &H100 + bytBuf(0)
    End If
End Function
'--------------------------------------------------------------
' ArrayList �� ICursor �C���^�[�t�F�[�X���擾
'--------------------------------------------------------------
Private Property Get IList_GetCursor() As ICursor
    Set IList_GetCursor = Me
End Property
'--------------------------------------------------------------
' ICursor I/F
'--------------------------------------------------------------
' ICursor �� Eof �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Eof() As Boolean
    ICursor_Eof = mIndex >= mCol.Count
End Property
'--------------------------------------------------------------
' ICursor I/F
'--------------------------------------------------------------
' ICursor �� Item �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_Item(Optional ByVal opt As Variant) As Variant
    
    If mIndex >= mCol.Count Then
        ICursor_Item = mCol(mCol.Count)
    Else
        ICursor_Item = mCol(mIndex + 1)
    End If
    
End Property
'--------------------------------------------------------------
' ICursor I/F
'--------------------------------------------------------------
' ICursor �� PreviousItem �v���p�e�B���擾
'--------------------------------------------------------------
Private Property Get ICursor_PreviousItem(Optional ByVal opt As Variant) As Variant
    
    If mIndex <= 0 Then
        Message.Throw 1, Me, "ICursor_PreviousItem", "IndexOutOfRangeException"
    Else
        ICursor_PreviousItem = mCol(mIndex)
    End If

End Property
'--------------------------------------------------------------
' ICursor I/F
'--------------------------------------------------------------
' ICursor �� �J�[�\���ʒu��������
'--------------------------------------------------------------
Private Sub ICursor_MoveFirst()
    mIndex = 0
End Sub
'--------------------------------------------------------------
' ICursor I/F
'--------------------------------------------------------------
' ICursor �� �J�[�\���ʒu�����Ɉړ�
'--------------------------------------------------------------
Private Sub ICursor_MoveNext()

    mIndex = mIndex + 1
    If mIndex > mCol.Count Then
        mIndex = mCol.Count
    End If

End Sub
