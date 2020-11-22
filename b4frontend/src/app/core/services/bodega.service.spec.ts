import { TestBed } from '@angular/core/testing';

import { BodegaService } from './bodega.service';

describe('BodegaService', () => {
  let service: BodegaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(BodegaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
