VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Arrays"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [Hidennotare] v2.5
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
'>### Arrays �N���X
'>
'>**Remarks**
'>
'>Arrays�N���X<br>
'>�z��Ɋ֌W���鑀����s���N���X<br>
'>**���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B**
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
'-----------------------------------------------------------------------------------------------------
'>---
'>#### ToCollection
'>
'>**Syntax**
'>
'>```
'>Set col = Arrays.ToCollection(args)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|args|�K�{|Variant|�`�F�b�N������z����w��|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|col|Collection|Collection��ԋp����|
'>
'>**Remarks**
'>
'>�z��܂���ParamArray��Collection�ɕϊ�<br>
'>
'>**Example**
'>
'-----------------------------------------------------------------------------------------------------
Public Function ToCollection(args As Variant) As Collection
        
    Dim col As Collection
    Dim v As Variant
    
    Set col = New Collection
        
    For Each v In args
        col.Add v
    Next

    Set ToCollection = col

End Function
'-----------------------------------------------------------------------------------------------------
'>---
'>#### ToList
'>
'>**Syntax**
'>
'>```
'>Set col = Arrays.ToList(args)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|args|�K�{|Variant|�ϊ�����z��܂���Collection���w��|
'>|obj|�C��|INewInstance|�ϊ����IList I/F �ȗ������ꍇ�AArrayList|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|col|Collection|Collection��ԋp����|
'>
'>**Remarks**
'>
'>�z��܂���Collection��ArrayList�ɕϊ�<br>
'>
'>**Example**
'>
'-----------------------------------------------------------------------------------------------------
Public Function ToList(ary As Variant, Optional ByVal obj As INewInstance = Nothing) As IList

    Dim lst As IList
    Dim v As Variant
       
    'ArrayList �Œ�
    If obj Is Nothing Then
        Set lst = ArrayList.NewInstance()
    Else
        Set lst = obj.NewInstance()
    End If
    
    If TypeOf ary Is Collection Or IsArray(ary) Then
    
        For Each v In ary
            lst.Add v
        Next
    
    End If
    
    Set ToList = lst

End Function
'>---
'>#### TryUbound
'>
'>**Syntax**
'>
'>```
'>flg = Arrays.TryUBound(ary, idx, [dimension = 1])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|ary|�K�{|Variant|�`�F�b�N������z����w��|
'>|idx|�K�{|Long|�z��̏����ԋp����ϐ����w��|
'>|dimension|�ȗ���|Long|�ȗ����P�i�����j�B�e�X�g���鎟�������w��|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|flg|Boolean|����:True / �G���[:False|
'>
'>**Remarks**
'>
'>�G���[���m�t��UBound<br>
'>�e�X�g����z�񂪂P�����̏ꍇ�ɂQ�����̏�������߂悤�Ƃ���Ǝ��s���G���[�ɂȂ�B<br>
'>���̂��߃G���[���m�\��Ubound�Ƃ��č쐬�B�G���[�̏ꍇ�ɂ� False ���ԋp�����B
'>
'>**Example**
'>
'>**See also**
'>
'>* Arrays.TryLBound
'>
Public Function TryUBound(ary As Variant, idx As Long, Optional ByVal dimension As Long = 1) As Boolean
 
    On Error GoTo e
    
    idx = UBound(ary, dimension)

    TryUBound = True
    
    Exit Function
e:
    TryUBound = False

End Function
'>---
'>#### TryLBound
'>
'>**Syntax**
'>
'>```
'>flg = Arrays.TryLBound(ary, idx, [dimension = 1])
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|ary|�K�{|Variant|�`�F�b�N������z����w��|
'>|idx|�K�{|Long|�z��̉�����ԋp����ϐ����w��|
'>|dimension|�ȗ���|Long|�ȗ����P�i�����j�B�e�X�g���鎟�������w��|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|flg|Boolean|����:True / �G���[:False|
'>
'>**Remarks**
'>
'>�G���[���m�t��UBound<br>
'>�e�X�g����z�񂪂P�����̏ꍇ�ɂQ�����̉��������߂悤�Ƃ���Ǝ��s���G���[�ɂȂ�B<br>
'>���̂��߃G���[���m�\��Ubound�Ƃ��č쐬�B�G���[�̏ꍇ�ɂ� False ���ԋp�����B
'>
'>**Example**
'>
'>**See also**
'>
'>* Arrays.TryUBound
'>
Public Function TryLBound(ary As Variant, lngIdx As Long, Optional ByVal dimension As Long = 1) As Boolean
 
    On Error GoTo e
    
    lngIdx = LBound(ary, dimension)

    TryLBound = True
    
    Exit Function
e:
    TryLBound = False

End Function
'>---
'>#### Length
'>
'>**Syntax**
'>
'>```
'>length = Arrays.Length(ary)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|ary|�K�{|Variant|�`�F�b�N������z����w��|
'>
'>**Return Value**
'>
'>|Name|Data type|Description|
'>---|---|---
'>|length|Long|�z��T�C�Y��ԋp|
'>
'>**Remarks**
'>
'>�z��̃T�C�Y�𒲂ׂ�<br>
'>�w�肳�ꂽ�z��̃T�C�Y��ԋp����<br>
'>
'>**Example**
'>
'>**See also**
'>
'>* Arrays.TryLBound
'>* Arrays.TryUBound
'>
Function Length(var As Variant) As Long

    Dim lngValue As Long
    Dim lngMin As Long
    Dim lngMax As Long
    
    If IsArray(var) Then
    
        If Me.TryLBound(var, lngValue) Then
            lngMin = lngValue
        End If
        
        If Me.TryUBound(var, lngValue) Then
            lngMax = lngValue
        End If
    
        Length = lngMax - lngMin + 1
    
    Else
        Err.Raise 512 + 1, TypeName(Me) & ".", "support array only"
    End If

End Function
'>---
'>#### CopyToListbox(Arrays)
'>
'>**Syntax**
'>
'>```
'>Arrays.CopyToListbox list, obj, Fields
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|IList|copy����IList I/F ���w��|
'>|obj|�K�{|Object|copy���� ListBox or ComboBox ���w��|
'>|Fields|�K�{|�t�B�[���h�����X�g�i�z��܂��̓R���N�V�����܂���IList�j|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListBox/ComboBox �փR�s�[<br>
'>ArrayList/LinkedList�̓��e��ListBox/ComboBox�ɃR�s�[����B<br>
'>ListBox/ComboBox��Tag��ArrayList�̃��R�[�h��Ή��Â���t�B�[���h�����X�g���K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� IValueObject �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>
'>    Arrays.CopyToListbox list, lstFavorite, Array(No, Name, Address)
'>
'>```
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* IValueObject
'>
Public Sub CopyToListbox(ary As IList, objList As Object, Fields As Variant)

    Dim objRec As Object
    Dim v As Variant

    'Tag�Ƀt�B�[���h��񂪖����ꍇ
    If objList.Tag = "" Then
        Err.Raise 512 + 1, TypeName(Me) & ".CopyToListbox", "Item name is not set in tag"
    End If

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
                objList.list(i, j) = Objects.AsIValueObject(objRec).Fields(v)
            End If
            j = j + 1
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### CopyToListObject(Arrays)
'>
'>**Syntax**
'>
'>```
'>Arrays.CopyToListObject list, objList
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
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� IValueObject �� Implements �����N���X�ł��邱�ƁB
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* ICompatibleProperty
'>
Public Sub CopyToListObject(lst As IList, LO As ListObject)

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

            LO.DataBodyRange.Cells(i, j).Value = Objects.AsIValueObject(objRec).Fields(LO.HeaderRowRange(, j).Value)
        
        Next
        i = i + 1
    Next

End Sub
'>---
'>#### CopyToRange(Arrays)
'>
'>**Syntax**
'>
'>```
'>Arrays.CopyToRange list, range
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|IList|copy����IList I/F ���w��|
'>|range|�K�{|Range|copy����V�[�g�͈̔�(Range)�̍�����w��|
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
Public Sub CopyToRange(lst As IList, TopLeft As Range)

    Dim v As Variant
    Dim lngRow As Long
    Dim lngCol As Long
    
    v = lst.ToArray
    
    If Not Arrays.TryUBound(v, lngRow, 1) Then
        Exit Sub
    End If
    If Not Arrays.TryUBound(v, lngCol, 2) Then
        Exit Sub
    End If

    TopLeft.resize(lngRow + 1, lngCol + 1).Value = v

End Sub
'>---
'>#### CopyToListView(Arrays)
'>
'>**Syntax**
'>
'>```
'>Arrays.CopyToListView list, obj, Fields
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|list|�K�{|IList|copy����IList I/F ���w��|
'>|obj|�K�{|Object|copy���� ListView ���w��|
'>|Fields|�K�{|�t�B�[���h�����X�g�i�z��܂��̓R���N�V�����܂���IList�j|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>ListView �փR�s�[<br>
'>ArrayList/LinkedList�̓��e��ListView�ɃR�s�[����B<br>
'>ArrayList�̒���IDictionay/IValueObject�ɑΉ��Â���t�B�[���h�����X�g���K�{�B<br>
'>���R�[�h�Ɏg�p����I�u�W�F�N�g�� INewInstance �� IValueObject �� Implements �����N���X�ł��邱�ƁB
'>
'>**Example**
'>
'>```
'>
'>    Arrays.CopyToListView list, lvwFavorite, Array(No, Name, Address)
'>
'>```
'>
'>**See also**
'>
'>* ArrayList
'>* LinkedList
'>* Dictionary
'>* INewInstance
'>* IValueObject
'>
Public Sub CopyToListView(ary As IList, objList As Object, Fields As Variant)

    Dim objRec As Object
    Dim v As Variant

    'Tag�Ƀt�B�[���h��񂪖����ꍇ
    If objList.Tag = "" Then
        Err.Raise 512 + 1, TypeName(Me) & ".IListToListbox", "Item name is not set in tag"
    End If

    'ListView�̃N���A
    objList.ListItems.Clear

    Dim i As Long
    Dim j As Long
    i = 0
    For Each objRec In ary
        j = 0
        For Each v In Fields

            '�ݒ肳��Ă���t�B�[���h�̂݃R�s�[����B
            If v <> "" Then
                If j = 0 Then
                    With objList.ListItems.Add
                        .Text = Objects.AsIValueObject(objRec).Fields(v)
                    End With
                Else
                    objList.ListItems(i + 1).SubItems(j) = Objects.AsIValueObject(objRec).Fields(v)
                
                End If
            End If
            j = j + 1
        Next
        i = i + 1
    Next

End Sub
