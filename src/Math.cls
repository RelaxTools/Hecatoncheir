VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Math"
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
' ���̃N���X�� Static�N���X(Attribute VB_PredeclaredId = True) �ł��B
'-----------------------------------------------------------------------------------------------------
' �ˑ����W���[��
'   �Ȃ�
'-----------------------------------------------------------------------------------------------------
' 2018-12-16 Ver.1.0.0 �V�K�쐬
'-----------------------------------------------------------------------------------------------------
Option Explicit

'--------------------------------------------------------------
'�J�E���^���C���N�������g
'--------------------------------------------------------------
Public Sub Incl(ByRef lngCnt As Long, Optional ByVal Incriment As Long = 1)
    lngCnt = lngCnt + Incriment
End Sub
'--------------------------------------------------------------
'�@�w�茅�ł̎l�̌ܓ�(decimal�^��Ώ�)
'--------------------------------------------------------------
Public Function Round(ByVal varNumber As Variant, ByVal lngDigit As Long) As Variant

    Round = Int(CDec(varNumber) * (10 ^ lngDigit) + CDec(0.5)) / 10 ^ lngDigit

End Function
'--------------------------------------------------------------
'�@�w�茅�ł̐؎̂�(decimal�^��Ώ�)
'--------------------------------------------------------------
Public Function RoundDown(ByVal varNumber As Variant, ByVal lngDigit As Long) As Variant

    RoundDown = Int(CDec(varNumber) * (10 ^ lngDigit)) / 10 ^ lngDigit

End Function
'--------------------------------------------------------------
'�@�w�茅�ł̐؏グ(decimal�^��Ώ�)
'--------------------------------------------------------------
Public Function RoundUp(ByVal varNumber As Variant, ByVal lngDigit As Long) As Variant

    Dim work As Variant
    Dim work2 As Variant

    work = Int(CDec(varNumber) * (10 ^ lngDigit))
    work2 = CDec(varNumber) * (10 ^ lngDigit)
    
    '�����_�ȉ������݂���ꍇ
    If work = work2 Then
    Else
        work = work + 1
    End If
    
    RoundUp = work / 10 ^ lngDigit

End Function
'------------------------------------------------------------------------------------------------------------------------
' ���ʃo�C�g�擾
'------------------------------------------------------------------------------------------------------------------------
Function LByte(ByVal lngValue As Long) As Long
    LByte = lngValue And &HFF&
End Function
'------------------------------------------------------------------------------------------------------------------------
' ��ʃo�C�g�擾
'------------------------------------------------------------------------------------------------------------------------
Function UByte(ByVal lngValue As Long) As Long
    UByte = RShift((lngValue And &HFF00&), 8)
End Function
'------------------------------------------------------------------------------------------------------------------------
' �E�V�t�g
'------------------------------------------------------------------------------------------------------------------------
Function RShift(ByVal lngValue As Long, ByVal lngKeta As Long) As Long
    RShift = lngValue \ (2 ^ lngKeta)
End Function
'------------------------------------------------------------------------------------------------------------------------
' ���V�t�g
'------------------------------------------------------------------------------------------------------------------------
Function LShift(ByVal lngValue As Long, ByVal lngKeta As Long) As Long
    LShift = lngValue * (2 ^ lngKeta)
End Function
