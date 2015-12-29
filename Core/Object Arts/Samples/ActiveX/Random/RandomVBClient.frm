VERSION 5.00
Begin VB.Form Random 
   Caption         =   "Dolphin Random Number Generator Client"
   ClientHeight    =   3675
   ClientLeft      =   60
   ClientTop       =   315
   ClientWidth     =   5820
   Icon            =   "RandomVBClient.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3675
   ScaleWidth      =   5820
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Properties"
      Height          =   2295
      Left            =   360
      TabIndex        =   2
      Top             =   1080
      Width           =   5175
      Begin VB.TextBox Seed 
         Height          =   375
         Left            =   1440
         TabIndex        =   12
         Top             =   1620
         Width           =   1215
      End
      Begin VB.TextBox UpperBound 
         Height          =   375
         Left            =   1440
         TabIndex        =   11
         Top             =   1020
         Width           =   1215
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Set Seed"
         Height          =   495
         Left            =   3000
         TabIndex        =   9
         Top             =   1560
         Width           =   1815
      End
      Begin VB.CommandButton SetUpperBound 
         Caption         =   "Set Upper Bound"
         Height          =   495
         Left            =   3000
         TabIndex        =   8
         Top             =   960
         Width           =   1815
      End
      Begin VB.CommandButton SetLowerBound 
         Caption         =   "Set Lower Bound"
         Height          =   495
         Left            =   3000
         TabIndex        =   6
         Top             =   360
         Width           =   1815
      End
      Begin VB.TextBox LowerBound 
         Height          =   375
         Left            =   1440
         TabIndex        =   4
         Top             =   420
         Width           =   1215
      End
      Begin VB.Label Label4 
         Alignment       =   1  'Right Justify
         Caption         =   "Seed:"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   1680
         Width           =   1215
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Upper Bound"
         Height          =   255
         Left            =   240
         TabIndex        =   7
         Top             =   1080
         Width           =   1095
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Lower Bound"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   480
         Width           =   1095
      End
      Begin VB.Label Label3 
         Caption         =   "Configuration"
         Height          =   255
         Left            =   0
         TabIndex        =   3
         Top             =   0
         Width           =   1095
      End
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   480
      TabIndex        =   1
      Top             =   240
      Width           =   1695
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Next"
      Height          =   495
      Left            =   2400
      TabIndex        =   0
      Top             =   240
      Width           =   1575
   End
End
Attribute VB_Name = "Random"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim R As New RANDOMLib.RandomStream

Private Sub Command1_Click()
    Text1 = R.Next
    Seed = R.Seed
End Sub

Private Sub Command2_Click()
    R.Seed = Seed
End Sub

Private Sub Form_Load()
    LowerBound = R.LowerBound
    UpperBound = R.UpperBound
    Seed = R.Seed
End Sub


Private Sub SetLowerBound_Click()
    R.LowerBound = LowerBound
End Sub

Private Sub SetUpperBound_Click()
    R.UpperBound = UpperBound
End Sub
