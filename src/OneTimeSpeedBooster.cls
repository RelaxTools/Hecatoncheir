VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OneTimeSpeedBooster"
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
' �}�N��������
'
' �}�N���̍������Ɋ�^����v���p�e�B��ݒ肷��B
'-----------------------------------------------------------------------------------------------------
' �ˑ��N���X�FIUsing
'-----------------------------------------------------------------------------------------------------
' t-hom�fs diary
' VBA �}�N���̍������̂��߂�Application�ݒ���N���X���W���[���ɂ܂Ƃ߂�
' https://thom.hateblo.jp/entry/2017/03/19/113657
'-----------------------------------------------------------------------------------------------------
' 2019-05-27 Ver.1.0.0 �V�K�쐬
'-----------------------------------------------------------------------------------------------------
Option Explicit
Implements IUsing

'Private mScreenUpdating As Boolean
'Private mCalculation As XlCalculation
'Private mEnableEvents As Boolean
'Private mPrintCommunication As Boolean
'Private mDisplayAlerts As Boolean

Private Sub IUsing_Begin()
    
'    'Application�̃v���p�e�B��ۑ�����B
'    With Application
'        mScreenUpdating = .ScreenUpdating
'        mCalculation = .Calculation
'        mEnableEvents = .EnableEvents
'        mPrintCommunication = .PrintCommunication
'        mDisplayAlerts = .DisplayAlerts
'    End With

    'Application�̃v���p�e�B��ύX����B
    With Application
        .ScreenUpdating = False
        .Calculation = xlCalculationManual
        .EnableEvents = False
        .PrintCommunication = False
        .DisplayAlerts = False
        
        .Cursor = xlWait
    End With

End Sub

Private Sub IUsing_Finish()
    
    '�v���O�����𒆒f����ƁAFalse�̂܂܂ɂȂ��Ă��܂��̂�
    '�ۑ��͂��Ȃ����������������Ȃ��B
    
    'Application�̃v���p�e�B�𕜌�����B
    With Application
'        .ScreenUpdating = mScreenUpdating
'        .Calculation = mCalculation
'        .EnableEvents = mEnableEvents
'        .PrintCommunication = mPrintCommunication
'        .DisplayAlerts = mDisplayAlerts
        
        .ScreenUpdating = True
        .Calculation = xlCalculationAutomatic
        .EnableEvents = True
        .PrintCommunication = True
        .DisplayAlerts = True
        
        .Cursor = xlDefault
        .StatusBar = False
    
    End With

End Sub
