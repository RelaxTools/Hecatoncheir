VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CoreEx"
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
'>### CoreEx �N���X
'>
'>**Remarks**
'>
'>CoreEx�N���X<br>
'>**���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B**
'>ArrayList/Dictionary���̃I�u�W�F�N�g�Ɉˑ�����֗����\�b�h��<br>
'>
'>**Dependent**
'>
'>* None
'>
'>**History**
'>
'>|Date|Version|Note|
'>|---|---|---|
'>|2019-01-01|Ver.1.0.0|�V�K�쐬|
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit
'>---
'>#### CastICompatibleProperty
'>
'>**Syntax**
'>
'>```
'>Set obj = Convert.CastICompatibleProperty(inObj)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>inObj|�K�{|ICompatibleProperty�ɑΉ������I�u�W�F�N�g|
'>
'>**Return Value**
'>
'>ICompatibleProperty�ɃL���X�g���ꂽ�I�u�W�F�N�g
'>
'>**Remarks**
'>
'>ICompatibleProperty�ϊ�<br>
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ICompatibleProperty
'>
Public Function CastICompatibleProperty(ByRef obj As Object) As ICompatibleProperty
    Set CastICompatibleProperty = obj
End Function
'-------------------------------------------------
' NewInstance
'-------------------------------------------------
Public Function GetNewInstance(obj As INewInstance) As Object
    Set GetNewInstance = obj.NewInstance
End Function
'>---
'>#### IlistToListbox(CoreEx)
'>
'>**Syntax**
'>
'>```
'>CoreEx.IListToListbox list, objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|IList|copy����IList I/F ���w��|
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListBox/ComboBox �փR�s�[<br>
'>ArrayList/LinkedList�̓��e��ListBox/ComboBox�ɃR�s�[����B<br>
'>ListBox/ComboBox��Tag��ArrayList�̃��R�[�h��Ή��Â���t�B�[���h�����X�g�i�J���}��؂�j���K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>    '����̓R�[�h�ł͂Ȃ��v���p�e�B�E�B���h�E�Őݒ肵�Ă��ǂ�
'>    lstFavorite.Tag = "No,Name,Address"
'>
'>    CoreEx.IListToListbox list, lstFavorite
'>
'>```
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub IListToListbox(ary As IList, objList As Object)

    Dim objRec As Object
    Dim Fields As Variant
    Dim v As Variant

    'Tag�Ƀt�B�[���h��񂪖����ꍇ
    If objList.Tag = "" Then
        Err.Raise 512 + 1, TypeName(Me) & ".IListToListbox", "Item name is not set in tag"
    End If

    '�z��ɕϊ�
    Fields = Split(objList.Tag, ",")

    '���X�g�{�b�N�X�̃N���A
    objList.Clear

    Dim i As Long
    Dim j As Long
    i = 0
    For Each objRec In ary
        j = 0
        objList.AddItem
        For Each v In Fields

            '�ݒ肳��Ă���t�B�[���h�̂݃R�s�[����B
            If v <> "" Then
                objList.list(i, j) = CoreEx.CastICompatibleProperty(objRec).GetProperty(v)
            End If
            j = j + 1
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### IListToListObject(CoreEx)
'>
'>**Syntax**
'>
'>```
'>CoreEx.IListToListObject list, objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|Ilist|copy����IList I/F ���w��|
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListObject(�e�[�u���@�\)�փR�s�[<br>
'>ArrayList�̓��e��Listobject�ɃR�s�[����B<br>
'>Listobject��ArrayList�̃��R�[�h��Ή��Â���񖼂��K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub IListToListObject(lst As IList, LO As ListObject)

    Dim objRec As Object
    Dim Fields As Variant
    Dim v As Variant

    '���X�g�I�u�W�F�N�g�̃N���A
    If Not LO.DataBodyRange Is Nothing Then
        LO.DataBodyRange.ClearContents
        LO.DataBodyRange.Delete
    End If
    
    Dim i As Long
    Dim j As Long
    
    i = 1
    For Each objRec In lst
        
        LO.ListRows.Add
        For j = 1 To LO.HeaderRowRange.Columns.Count

            LO.DataBodyRange.Cells(i, j).Value = CoreEx.CastICompatibleProperty(objRec).GetProperty(LO.HeaderRowRange(, j).Value)
        
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### IListToRange(CoreEx)
'>
'>**Syntax**
'>
'>```
'>CoreEx.IListToRange list, objct
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|IList|copy����IList I/F ���w��|
'>|object|�K�{|Range|copy����V�[�g�͈̔�(Range)�̍�����w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ArrayList���V�[�g�֓\��t����<br>
'>�w�肳�ꂽRange���N�_��ArrayList�̓��e��\��t����<br>
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub IListToRange(lst As IList, TopLeft As Range)

    Dim v As Variant
    Dim lngRow As Long
    Dim lngCol As Long
    
    v = lst.ToArray
    
    If Not Core.TryUBound(v, lngRow, 1) Then
        Exit Sub
    End If
    If Not Core.TryUBound(v, lngCol, 2) Then
        Exit Sub
    End If

    TopLeft.resize(lngRow + 1, lngCol + 1).Value = v

End Sub
'>---
'>#### IDictionaryToListbox(CoreEx)
'>
'>**Syntax**
'>
'>```
'>CoreEx.IDictionaryToListbox dic, objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|dic|�K�{|Object|copy����IDictionary I/F���w��|
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListBox/ComboBox �փR�s�[<br>
'>ArrayList�̓��e��ListBox/ComboBox�ɃR�s�[����B<br>
'>ListBox/ComboBox��Tag��Dictionary�̃��R�[�h��Ή��Â���t�B�[���h�����X�g�i�J���}��؂�j���K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>    '����̓R�[�h�ł͂Ȃ��v���p�e�B�E�B���h�E�Őݒ肵�Ă��ǂ�
'>    lstFavorite.Tag = "No,Name,Address"
'>
'>    CoreEx.IDictionaryToListbox dic, lstFavorite
'>
'>```
'>
'>**See also**
'>
'>* Dictionary.ParseFromListbox
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub IDictionaryToListbox(ary As IDictionary, objList As Object)

    Dim objRec As Object
    Dim Fields As Variant
    Dim v As Variant
    Dim Key As Variant

    'Tag�Ƀt�B�[���h��񂪖����ꍇ
    If objList.Tag = "" Then
        Err.Raise 512 + 1, TypeName(Me) & ".CopyToListbox", "Item name is not set in tag"
    End If

    '�z��ɕϊ�
    Fields = Split(objList.Tag, ",")

    '���X�g�{�b�N�X�̃N���A
    objList.Clear

    Dim i As Long
    Dim j As Long
    i = 0
    For Each Key In ary.Keys
    
        Set objRec = ary.Item(Key)
    
        j = 0
        objList.AddItem
        For Each v In Fields

            '�ݒ肳��Ă���t�B�[���h�̂݃R�s�[����B
            If v <> "" Then
                objList.list(i, j) = CoreEx.CastICompatibleProperty(objRec).GetProperty(v)
            End If
            j = j + 1
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### IDictionaryToListObject(CoreEx)
'>
'>**Syntax**
'>
'>```
'>CoreEx.IDictionaryToListObject dic, objList
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|dic|�K�{|Object|copy����IDictionary I/F���w��|
'>|objList|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListObject(�e�[�u���@�\)�փR�s�[<br>
'>ArrayList�̓��e��Listobject�ɃR�s�[����B<br>
'>Listobject��Dictionary�̃��R�[�h��Ή��Â���񖼂��K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� ICompatibleProperty �� Implements �����N���X�ł��邱�ƁB
'>
'>**See also**
'>
'>* Dictionary
'>* OrderdDictionary
'>* SortedDictionary
'>* MRecord
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub IDictionaryToListObject(lst As IDictionary, LO As ListObject)

    Dim Key As Variant
    Dim obj As Object
    Dim v As Variant

    '���X�g�I�u�W�F�N�g�̃N���A
    If Not LO.DataBodyRange Is Nothing Then
        LO.DataBodyRange.ClearContents
        LO.DataBodyRange.Delete
    End If
    
    Dim i As Long
    Dim j As Long
    
    i = 1
    For Each Key In lst.Keys
        
        Set obj = lst.Item(Key)
        
        LO.ListRows.Add
        For j = 1 To LO.HeaderRowRange.Columns.Count

            LO.DataBodyRange.Cells(i, j).Value = CoreEx.CastICompatibleProperty(obj).GetProperty(LO.HeaderRowRange(, j).Value)
        
        Next
        i = i + 1
    Next

End Sub