VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Zip"
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
'>### Zip �N���X
'>
'>**Remarks**
'>
'>Zip �N���X<br>
'>Zip �t�@�C���̑��삪�\(PowerShell�𗘗p�B.NetFramework 4.5�ȏ�K�{)<br>
'>**���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B**
'>
'>**Dependent**
'>
'>- None
'>
'>**History**
'>
'>|Date|Version|Note|
'>|---|---|---|
'>|2019-10-17|Ver.1.0.0|�V�K�쐬|
'>
'-----------------------------------------------------------------------------------------------------
Option Explicit
'>---
'>#### CompressArchive(Zip)
'>
'>**Syntax**
'>
'>```
'>Zip.CompressArchive(ary, zipfile)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>---|---|---|---
'>|ary|�K�{|Array|���k����t�@�C����z��Ŏw��|
'>|zipfile|�K�{|String|�쐬����Zip�t�@�C�����w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>Zip���k<br>
'>�w�肳�ꂽ�t�@�C�������k���āAZip�t�@�C�����쐬���܂��B<br>
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* Zip.ExpandArchive
'>
Public Sub CompressArchive(ByVal ary As Variant, ByVal strDest As String)

    Dim SB As IStringBuilder
    Dim PH As IStringBuilder
    Dim v As Variant
    
    If Not strDest Like "*.zip" Then
        Err.Raise 512 + 1, TypeName(Me) & ".CompressArchive", "support zip only"
    End If
    
    Dim strParent As String
    strParent = FileIO.GetParentFolderName(strDest)
    If Not FileIO.FolderExists(strParent) Then
        Err.Raise 512 + 1, TypeName(Me) & ".CompressArchive", "not exists folder " & strParent
    End If
    
    If Not IsArray(ary) Then
        ary = Array(ary)
    End If
    
    For Each v In ary
        If Not FileIO.FolderExists(v) And Not FileIO.FileExists(v) Then
            Err.Raise 512 + 1, TypeName(Me) & ".CompressArchive", "not exists file/folder " & v
        End If
    Next
    
    Set SB = StringBuilder.CreateObject
    
    '�R�}���h
    SB.Append "Compress-Archive"
    
    '���k����t�@�C��
    SB.Append "-Path"
    Set PH = StringBuilder.CreateObject
    For Each v In ary
    
        PH.Append v, True
    
    Next
    SB.Append PH.ToString(",")
    
    '�o�̓p�X
    SB.Append "-DestinationPath"
    SB.Append strDest, True

    SB.Append "-Force"
    
    'PowerShell �����s����
    Process.ExecPowerShell SB.ToString(" ")

End Sub
'>---
'>#### ExpandArchive(Zip)
'>
'>**Syntax**
'>
'>```
'>Zip.ExpandArchive(zipfile, path)
'>```
'>
'>**Parameters**
'>
'>|Name|Required/Optional|Data type|Description|
'>|zipfile|�K�{|String|Zip�t�@�C���w��|
'>|path|�K�{|String|�W�J����t�H���_���w��|
'>
'>**Return Value**
'>
'>* None
'>
'>**Remarks**
'>
'>Zip�W�J<br>
'>Zip�t�@�C�����w�肳�ꂽ�t�H���_�ɓW�J���܂��B<br>
'>
'>**Example**
'>
'>* None
'>
'>**See also**
'>
'>* Zip.CompressArchive
'>
Public Sub ExpandArchive(ByVal strArchive As String, ByVal strPath As String)

    If Not strArchive Like "*.zip" Then
        Err.Raise 512 + 1, TypeName(Me) & ".ExpandArchive", "support zip only"
    End If
    
    If Not FileIO.FileExists(strArchive) Then
        Err.Raise 512 + 1, TypeName(Me) & ".ExpandArchive", "zip file not exists"
    End If
    
    If Not FileIO.FolderExists(strPath) Then
        Err.Raise 512 + 1, TypeName(Me) & ".ExpandArchive", "folder not exists"
    End If
    
    Dim SB As IStringBuilder
    
    Set SB = StringBuilder.CreateObject
    
    '�R�}���h
    SB.Append "Expand-Archive"
    
    'ZIP�t�@�C��
    SB.Append "-LiteralPath"
    SB.Append strArchive, True
    
    '�o�̓p�X
    SB.Append "-DestinationPath"
    SB.Append strPath, True

    SB.Append "-Force"
    
    'PowerShell �����s����
    Process.ExecPowerShell SB.ToString(" ")

End Sub