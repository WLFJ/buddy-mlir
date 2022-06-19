module{
    func.func private @printMemrefF32(memref<*xf32>)

    func.func @gemm(%a : memref<?x?xf32>, %b : memref<?x?xf32>, %c : memref<?x?xf32>) {
      linalg.matmul 
        ins(%a, %b: memref<?x?xf32>, memref<?x?xf32>)
       outs(%c:memref<?x?xf32>)
      return
    }

    func.func @main(){
       %cM = arith.constant 4 : index
       %cN = arith.constant 4 : index
       %cK = arith.constant 4 : index

       %cf1 = arith.constant 1.0 : f32

       %A = memref.alloc(%cM, %cK) : memref<?x?xf32>
       %B = memref.alloc(%cK, %cN) : memref<?x?xf32>
       %C = memref.alloc(%cM, %cN) : memref<?x?xf32>

       linalg.fill
        ins(%cf1 : f32)
       outs(%A:memref<?x?xf32>)

       linalg.fill
        ins(%cf1 : f32)
       outs(%B:memref<?x?xf32>)

       linalg.fill
        ins(%cf1 : f32)
       outs(%C:memref<?x?xf32>)

       call @gemm(%A, %B, %C) : (memref<?x?xf32>, memref<?x?xf32>, memref<?x?xf32>) -> ()

       %print_C = memref.cast %C : memref<?x?xf32> to memref<*xf32>
       call @printMemrefF32(%print_C) : (memref<*xf32>) -> ()
       return 
    }
}
