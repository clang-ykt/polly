; RUN: opt -S %loadPolly -polly-dependences -analyze < %s | FileCheck %s

; CHECK: RAW dependences:
; CHECK:   { Stmt_bb9[0] -> Stmt_bb10[0] }
; CHECK: WAR dependences:
; CHECK:   { Stmt_bb3[0] -> Stmt_bb10[0] }
; CHECK: WAW dependences:
; CHECK:   {  }
; CHECK: Reduction dependences:
; CHECK:   {  }

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @hoge(i32 %arg, [1024 x double]* %arg1) {
bb:
  br label %bb2

bb2:                                              ; preds = %bb
  br label %bb3

bb3:                                              ; preds = %bb10, %bb2
  %tmp = phi i64 [ 0, %bb10 ], [ 0, %bb2 ]
  %tmp4 = icmp sgt i32 %arg, 0
  %tmp5 = getelementptr inbounds [1024 x double], [1024 x double]* %arg1, i64 0, i64 0
  %tmp6 = load double, double* %tmp5, align 8
  %tmp7 = fadd double undef, %tmp6
  br i1 false, label %bb8, label %bb9

bb8:                                              ; preds = %bb3
  br label %bb10

bb9:                                              ; preds = %bb3
  br label %bb10

bb10:                                             ; preds = %bb9, %bb8
  %tmp11 = phi double [ undef, %bb8 ], [ undef, %bb9 ]
  %tmp12 = getelementptr inbounds [1024 x double], [1024 x double]* %arg1, i64 %tmp, i64 0
  store double %tmp11, double* %tmp12, align 8
  %tmp13 = add nuw nsw i64 0, 1
  %tmp14 = trunc i64 %tmp13 to i32
  br i1 false, label %bb3, label %bb15

bb15:                                             ; preds = %bb10
  br label %bb16

bb16:                                             ; preds = %bb15
  ret void
}