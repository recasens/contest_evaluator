Changes:

(1) In fconvblas.cc, changed int for ptrdiff_t:
      ptrdiff_t m = C_dims[0];
      ptrdiff_t n = B_dims[1]*B_dims[2];
      ptrdiff_t lda = A_dims[0];
      ptrdiff_t incx = 1;
      ptrdiff_t incy = 1;

(2) In process.m, disable getboxes() because just the root filter is 
    being trianed.

(3)


DOUBTS:
(1) Latent svm
(2) removing getboxes() function form process.m
(3) Am I doing hard negative mining? Look at detectme_train.m and
    everything that is removed.
(4) thresh in the model.
