open Core
open Print_parsed_ast

let%expect_test "Simple linear class" =
  print_parsed_ast
    " 
    class Foo = linear Bar {
      var f : int
    }
    linear trait Bar {
      require var f : int
    }
    let x = new Foo() in 
      x.f:= 5
    end
  " ;
  [%expect
    {|
    Program
    └──Class: Foo
       └──CapTrait: Bar
          └──Cap: Linear
       └──Field Defn: f
          └──Mode: Var
          └──TField: Int
    └──Trait: Bar
       └──Cap: Linear
       └──Require
          └──Field Defn: f
             └──Mode: Var
             └──TField: Int
    └──Expr: Let var: x
       └──Expr: Constructor for: Foo
       └──Expr: Assign: x.f
          └──Expr: Int:5 |}]

let%expect_test "Simple thread class" =
  print_parsed_ast
    " 
    class Foo = thread Bar {
      var f : int
    }
    thread trait Bar {
      require var f : int
    }
    let x = new Foo() in 
      x.f:= 5
    end
  " ;
  [%expect
    {|
    Program
    └──Class: Foo
       └──CapTrait: Bar
          └──Cap: Thread
       └──Field Defn: f
          └──Mode: Var
          └──TField: Int
    └──Trait: Bar
       └──Cap: Thread
       └──Require
          └──Field Defn: f
             └──Mode: Var
             └──TField: Int
    └──Expr: Let var: x
       └──Expr: Constructor for: Foo
       └──Expr: Assign: x.f
          └──Expr: Int:5 |}]

let%expect_test "Simple read class" =
  print_parsed_ast
    " 
    class Foo = read Bar {
      const f : int
    }
    read trait Bar {
      require const f : int
    }
    let x = new Foo(f:5) in 
      x.f
    end
  " ;
  [%expect
    {|
    Program
    └──Class: Foo
       └──CapTrait: Bar
          └──Cap: Read
       └──Field Defn: f
          └──Mode: Const
          └──TField: Int
    └──Trait: Bar
       └──Cap: Read
       └──Require
          └──Field Defn: f
             └──Mode: Const
             └──TField: Int
    └──Expr: Let var: x
       └──Expr: Constructor for: Foo
          └── Field: f
             └──Expr: Int:5
       └──Expr: Objfield: x.f |}]
